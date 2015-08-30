//
//  ShoppingListController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 04.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class ShoppingListViewController : AutoCompletionViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, MLPAutoCompleteTextFieldDataSource {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var quickAddButton: UIButton!
    @IBOutlet weak var quickAddTextField: AutoCompleteTextField!
    @IBOutlet weak var shoppingListTableView: UITableView!
    
    var returnToListOfShoppingListsDelegateMethod: (UIViewController -> ())?
    var closeKeyboardTapGestureRecognizer : UITapGestureRecognizer?
    
    let dbHelper = DatabaseHelper.instance
    let autoCompletionHelper = AutoCompletionHelper.instance
    let itemParser = ItemParser()
    
    var shoppingList : ShoppingList!
    var items : [Item] {
        get {
            return shoppingList.items
        }
        set {
            shoppingList.items = newValue
        }
    }
    var boughtItems : [Item] {
        get {
            return shoppingList.boughtItems
        }
        set {
            shoppingList.boughtItems = newValue
        }
    }
    var notBoughtItems : [Item] {
        get {
            return shoppingList.notBoughtItems
        }
        set {
            shoppingList.notBoughtItems = newValue
        }
    }
    
    override var hidesBottomBarWhenPushed : Bool {
        get {
            return true
        }
        set {
            
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quickAddButton.setTitle("shopping_list_quick_add_button".localized, forState: UIControlState.Normal)
        
        shoppingListTableView.delegate = self
        shoppingListTableView.dataSource = self
        
        assert(shoppingList != nil, "No shopping list was handed to Shopping List View")
        
        shoppingListTableView.estimatedRowHeight = 44.0
        shoppingListTableView.rowHeight = UITableViewAutomaticDimension
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipedView:")
        shoppingListTableView.addGestureRecognizer(swipeGestureRecognizer)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognized:")
        shoppingListTableView.addGestureRecognizer(longPressGestureRecognizer)
        
        quickAddTextField.delegate = self
        
        initializeAutoCompletionTextField(quickAddTextField, withDataSource: self)
    }
    
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(
            { (context) -> () in
                if let indexPaths = self.shoppingListTableView.indexPathsForVisibleRows() {
                    self.shoppingListTableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
                }
            },
            completion: nil)
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        var count = notBoughtItems.count
        let boughtCount = boughtItems.count
        if boughtCount > 0 {
            count += boughtCount + 1
        }
        return count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        
        if indexPath.row == notBoughtItems.count {
            let cellIdentifier = "ShoppingListSeperatorTableViewCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ShoppingListSeperatorTableViewCell
            cell.shoppingCartLabel.text = "shopping_list_seperator".localized
            return cell
        }
        
        let index = getIndexForIndexPath(indexPath)!
        
        let cellIdentifier = "ItemTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ItemTableViewCell
        
        let item = items[index]
        
        if item.bought {
            let itemName = item.name
            let strikeThroughText = NSMutableAttributedString(string: itemName)
            let itemNameRange = NSMakeRange(0, strikeThroughText.length)
            strikeThroughText.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: itemNameRange)
            strikeThroughText.addAttribute(NSFontAttributeName, value: cell.brandCommentLabel.font, range: itemNameRange)
            strikeThroughText.addAttribute(NSForegroundColorAttributeName, value: cell.brandCommentLabel.textColor, range: itemNameRange)
            cell.nameLabel.attributedText = strikeThroughText
            
            cell.brandCommentLabel.text = ""
            cell.amountLabel.text = ""
        } else {
            
            let brand = item.brand ?? ""
            let comment = item.comment ?? ""
            
            var brandCommentText = brand
            if !brand.isEmpty && !comment.isEmpty {
                brandCommentText += "\n"
            }
            brandCommentText += comment
            
            cell.brandCommentLabel.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds)
            
            cell.brandCommentLabel.text = brandCommentText
            cell.brandCommentLabel.numberOfLines = 0
            cell.brandCommentLabel.lineBreakMode = .ByWordWrapping
            cell.brandCommentLabel.sizeToFit()
            

            var amountText = ""
            
            let unit = item.unit
            if let amount = item.amount {
                let unit = item.unit
                if !unit.shortestPossibleDescription.isEmpty {
                    if amount == 1 {
                        amountText = "\(amount) \(unit.shortestPossibleSingularDescription)"
                    } else {
                        amountText = "\(amount) \(unit.shortestPossibleDescription)"
                    }
                } else {
                    amountText = "\(amount)"
                }
            } else if !unit.shortestPossibleDescription.isEmpty {
                // if no amount was specified, display unit name in singular
                amountText = "\(unit.shortestPossibleSingularDescription)"
            }
            
            cell.amountLabel.text = amountText
            
            cell.nameLabel.text = item.name
            if item.highlighted {
                cell.nameLabel.highlightedTextColor = UIColor.redColor()
                cell.nameLabel.highlighted = true
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            deleteItemAtIndexPath(indexPath)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.row != notBoughtItems.count
    }
    
    // MARK: MLP Autocompletion
    func autoCompleteTextField(textField: MLPAutoCompleteTextField!, possibleCompletionsForString string: String!) -> [AnyObject]! {
        if textField === self.quickAddTextField {
            if let nameAmountAndUnit = itemParser.getNameAmountAndUnitForInput(string) {
                return autoCompletionHelper.possibleCompletionsForQuickAddTextWithName(nameAmountAndUnit.name ?? "", amount: nameAmountAndUnit.amount, andUnit: nameAmountAndUnit.unit)
            }
        }
        return [AnyObject]()
    }
    
    // MARK: UIGestureRecognizerDelegate
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if gestureRecognizer === closeKeyboardTapGestureRecognizer && touch.view.isDescendantOfView(quickAddTextField.autoCompleteTableView) {
            // autocomplete suggestion was tapped
            return false;
        }
        // somewhere else was tapped
        return true;
    }
    
    // MARK: Swipe Gesture
    func swipedView(sender : UISwipeGestureRecognizer) {
        let location = sender.locationInView(shoppingListTableView)
        if let indexPath = shoppingListTableView.indexPathForRowAtPoint(location) {
            
            let indexAndIndexPaths = getIndexAndIndexPathsForIndexPath(indexPath)
            
            if let index = indexAndIndexPaths.index {
                let boughtBeforeSwipe = items[index].bought
                let item = items.removeAtIndex(index)
                
                shoppingListTableView.deleteRowsAtIndexPaths(indexAndIndexPaths.indexPaths, withRowAnimation: .Fade)
                item.bought = !item.bought
                
                if boughtBeforeSwipe {
                    notBoughtItems.append(item)
                    let newIndexPath = NSIndexPath(forRow: notBoughtItems.count - 1, inSection: 0)
                    shoppingListTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                } else {
                    boughtItems.append(item)
                    let newIndexPath = NSIndexPath(forRow: items.count, inSection: 0)
                    let newIndexPaths = getIndexAndIndexPathsForIndexPath(newIndexPath).indexPaths
                    shoppingListTableView.insertRowsAtIndexPaths(newIndexPaths, withRowAnimation: .Bottom)
                }
                updateModifyDate()
                saveToDatabase()
            } else {
                // Swiped the shoppinglist separator
                return
            }
        }
    }
    
    // MARK: Drag and Drop
    private var dragAndDropCell : UITableViewCell?
    
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        var locationInView = longPress.locationInView(shoppingListTableView)
        var indexPath = shoppingListTableView.indexPathForRowAtPoint(locationInView)
        
        struct My {
            static var cellSnapshot : UIView? = nil
        }
        struct Path {
            static var initialIndexPath : NSIndexPath? = nil
        }
        
        
        switch state {
        case UIGestureRecognizerState.Began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                let cell = shoppingListTableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
                My.cellSnapshot  = snapshopOfCell(cell)
                var center = cell.center
                My.cellSnapshot!.center = center
                My.cellSnapshot!.alpha = 0.0
                shoppingListTableView.addSubview(My.cellSnapshot!)
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    center.y = locationInView.y
                    My.cellSnapshot!.center = center
                    My.cellSnapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05)
                    My.cellSnapshot!.alpha = 0.98
                    cell.alpha = 0.0
                    }, completion: { (finished) -> Void in
                        if finished {
                            cell.hidden = true
                        }
                })
            }
        case UIGestureRecognizerState.Changed:
            var center = My.cellSnapshot!.center
            center.y = locationInView.y
            My.cellSnapshot!.center = center
            if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                
                let shoppingListIndex = getIndexAndIndexPathsForIndexPath(indexPath!).index
                let shoppingListInitialIndex = getIndexAndIndexPathsForIndexPath(Path.initialIndexPath!).index
                
                let numberOfBoughtItemsBeforeSwap = boughtItems.count
                let numberOfNotBoughtItemsBeforeSwap = notBoughtItems.count
                self.dragAndDropCell = shoppingListTableView.cellForRowAtIndexPath(Path.initialIndexPath!)
                if !(shoppingListInitialIndex == nil && numberOfBoughtItemsBeforeSwap == 0) {
                    shoppingList.swapItemsAtIndices(initialIndex: shoppingListInitialIndex, newIndex: shoppingListIndex)
                }
                let numberOfBoughtItemsAfterSwap = boughtItems.count
                
                saveToDatabase()
                
                shoppingListTableView.beginUpdates()
                
                if shoppingListInitialIndex != nil || numberOfBoughtItemsAfterSwap > 0 {
                    shoppingListTableView.moveRowAtIndexPath(Path.initialIndexPath!, toIndexPath: indexPath!)
                }
                if shoppingListInitialIndex == nil && numberOfBoughtItemsBeforeSwap == 0 {
                    // shopping list separator is at the very bottom and moving up again
                    shoppingList.swapItemsAtIndices(initialIndex: nil, newIndex: items.count - 1)
                    shoppingListTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: items.count, inSection: 0)], withRowAnimation: .None)
                } else if numberOfBoughtItemsAfterSwap == 0 && numberOfBoughtItemsBeforeSwap > 0 {
                    // the last bought item has been moved up
                    let indexPath = NSIndexPath(forRow: numberOfNotBoughtItemsBeforeSwap, inSection: 0)
                    shoppingListTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                }
                shoppingListTableView.endUpdates()
                
                Path.initialIndexPath = indexPath
            }
        case UIGestureRecognizerState.Ended:
            if let indexPaths = shoppingListTableView.indexPathsForVisibleRows() {
                shoppingListTableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
            }
            fallthrough
        default:
            var cell = shoppingListTableView.cellForRowAtIndexPath(Path.initialIndexPath!) as UITableViewCell!
            if cell == nil {
                cell = self.dragAndDropCell
            }
            cell.hidden = false
            cell.alpha = 0.0
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                My.cellSnapshot!.center = cell.center
                My.cellSnapshot!.transform = CGAffineTransformIdentity
                My.cellSnapshot!.alpha = 0.0
                cell.alpha = 1.0
                }, completion: { (finished) -> Void in
                    if finished {
                        Path.initialIndexPath = nil
                        My.cellSnapshot!.removeFromSuperview()
                        My.cellSnapshot = nil
                    }
            })
            
        }
    }
    
    func snapshopOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
    // MARK: Actions
    
    func updateModifyDate () {
        let now = NSDate()
        shoppingList.lastModifiedDate = now
    }
    
    func saveToDatabase() {
        dbHelper.saveData()
    }
    
    private func deleteItemAtIndexPath(indexPath: NSIndexPath) {
        let indexAndIndexPaths = getIndexAndIndexPathsForIndexPath(indexPath)
        let index = indexAndIndexPaths.index! // index != nil because the separator can't be swiped or edited
        let indexPaths = indexAndIndexPaths.indexPaths
        
        let item = items.removeAtIndex(index)
        updateModifyDate()
        dbHelper.deleteItem(item)
        shoppingListTableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
    }
    
    private func getIndexAndIndexPathsForIndexPath(indexPath: NSIndexPath) -> (index: Int?, indexPaths: [NSIndexPath]) {
        let index = getIndexForIndexPath(indexPath)
        if index == nil {
            return (nil, [indexPath])
        }
        let indexPaths : [NSIndexPath]
        if index == notBoughtItems.count && boughtItems.count == 1 {
            let separatorIndexPath = NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)
            indexPaths = [separatorIndexPath, indexPath]
        } else {
            indexPaths = [indexPath]
        }
        return (index, indexPaths)
    }
    
    private func getIndexForIndexPath(indexPath: NSIndexPath) -> Int? {
        if indexPath.row < notBoughtItems.count {
            return indexPath.row
        } else if indexPath.row == notBoughtItems.count {
            return nil
        } else {
            return indexPath.row - 1
        }
    }

    @IBAction func quickAddPressed(sender: UIButton) {
        if let item = itemParser.getItemWithParsedAmountAndUnitForInput(quickAddTextField.text) {
            quickAddTextField.text = ""
            quickAddButton.enabled = false
            quickAddTextField.autoCompleteTableViewHidden = true
            addItem(item)
        }
    }
    
    func addItem(item: Item) {
        
        //for otherItem in notBoughtItems {
        for index in 0 ..< notBoughtItems.count {
            let otherItem = notBoughtItems[index]
            if item.isMergableWithOtherItem(otherItem) {
                if otherItem.amount == nil {
                    // other item has no amount. but a unit specified -> implicitly interpret as amount "1"
                    otherItem.amount = 1
                }
                if item.amount != nil {
                    otherItem.amount! += item.amount!
                } else {
                    // item has no amount. but a unit specified -> implicitly interpret as amount "1"
                    otherItem.amount! += 1
                }
                dbHelper.deleteItem(item)
                updateModifyDate()
                saveToDatabase()
                shoppingListTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Bottom)
                return
            }
        }
        
        let newIndexPath = NSIndexPath(forRow: notBoughtItems.count, inSection: 0)
        notBoughtItems.append(item)
        shoppingListTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        updateModifyDate()
        autoCompletionHelper.createOrUpdateAutoCompletionDataForItem(item)
        saveToDatabase()
    }    
    
    // MARK: Navigaton
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    private var selectedIndexPath : NSIndexPath?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowItemDetails" {
            let itemDetailsViewController = segue.destinationViewController as! ItemDetailsViewController
            if let selectedItemCell = sender as? ItemTableViewCell {
                selectedIndexPath = shoppingListTableView.indexPathForSelectedRow()
                
                let indexPath = shoppingListTableView.indexPathForCell(selectedItemCell)!
                let index = getIndexForIndexPath(indexPath)
                let selectedItem = items[index!] // index can't be nil because otherwise the as? cast would fail
                itemDetailsViewController.currentItem = selectedItem
                itemDetailsViewController.newItem = false
            }
        }
        else if segue.identifier == "AddItem" {
            if !quickAddTextField.text.isEmpty {
                let navigationController = segue.destinationViewController as! NavigationController
                let itemDetailsViewController = navigationController.topViewController as! ItemDetailsViewController
                if !quickAddTextField.text.isEmpty {
                    if let nameAmountAndUnit = itemParser.getNameAmountAndUnitForInput(quickAddTextField.text) {
                        let item = itemParser.getItemForParsedAmountAndUnit((nameAmountAndUnit.name ?? "", nameAmountAndUnit.amount, nameAmountAndUnit.unit))
                        itemDetailsViewController.currentItem = item
                    }
                }
                itemDetailsViewController.newItem = true
                quickAddTextField.text = ""
                closeKeyboard()
            }
        }
    }
    
    @IBAction func unwindToShoppingList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? ItemDetailsViewController {
            if !sourceViewController.newItem {
                if let selectedIndexPath = self.selectedIndexPath {
                    let index = getIndexForIndexPath(selectedIndexPath)!
                    if let item = sourceViewController.currentItem {
                        // item was changed
                        items[index] = sourceViewController.currentItem!
                        shoppingListTableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
                        updateModifyDate()
                        autoCompletionHelper.createOrUpdateAutoCompletionDataForItem(item)
                        saveToDatabase()
                    } else {
                        // item is to be deleted
                        deleteItemAtIndexPath(selectedIndexPath)
                    }
                } else {
                    assertionFailure("Returning from item details for an existing item allthough no table row was selected")
                }
            } else {
                let item = sourceViewController.currentItem! // item can only be nil if delete was pressed
                addItem(item)
            }
        }
    }
    
    override func viewWillDisappear(animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController()){
            if let returnMethod = returnToListOfShoppingListsDelegateMethod {
                returnMethod(self)
            }
        }
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        if quickAddTextField.text.isEmpty {
            closeKeyboard()
        } else {
            quickAddPressed(quickAddButton)
        }
        return true
    }
    
    func closeKeyboard() {
        quickAddTextField.resignFirstResponder()
        if let tap = closeKeyboardTapGestureRecognizer {
            view.removeGestureRecognizer(tap)
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        quickAddTextField.autoCompleteTableViewHidden = false
        let text = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        checkValidItemName(text)
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidItemName(textField.text)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // close keyboard when user taps on the view
        if closeKeyboardTapGestureRecognizer == nil {
            closeKeyboardTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "closeKeyboard")
            closeKeyboardTapGestureRecognizer!.delegate = self
        }
        view.addGestureRecognizer(closeKeyboardTapGestureRecognizer!)
    }
    
    func checkValidItemName(text: String) {
        // Disable the Save button if the text field is empty.
        var valid = true
        if text.isEmpty {
            valid = false
        } else {
            var digitsAndSpaces = NSMutableCharacterSet.decimalDigitCharacterSet()
            digitsAndSpaces.formUnionWithCharacterSet(NSCharacterSet.whitespaceCharacterSet())
            let textCharSet = NSCharacterSet(charactersInString: text)
            if digitsAndSpaces.isSupersetOfSet(textCharSet) {
                // the entered text only contains digits
                valid = false
            }
        }
        quickAddButton.enabled = valid
    }
    
    deinit {
        shoppingListTableView.editing = false
    }

}