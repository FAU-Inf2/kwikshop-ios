//
//  ShoppingListController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 04.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class ShoppingListViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var quickAddButton: UIButton!
    @IBOutlet weak var quickAddTextField: UITextField!
    @IBOutlet weak var shoppingListTableView: UITableView!
    
    var returnToListOfShoppingListsDelegateMethod: (UIViewController -> ())?
    var closeKeyboardTapGestureRecognizer : UITapGestureRecognizer?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shoppingListTableView.delegate = self
        shoppingListTableView.dataSource = self
        
        assert(shoppingList != nil, "No shopping list was handed to Shopping List View")
        
        shoppingListTableView.estimatedRowHeight = 44.0
        shoppingListTableView.rowHeight = UITableViewAutomaticDimension
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipedView:")
        shoppingListTableView.addGestureRecognizer(swipeGestureRecognizer)
        
        quickAddTextField.delegate = self
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(
            { (context) -> () in
                if let indexPaths = self.shoppingListTableView.indexPathsForVisibleRows() {
                    self.shoppingListTableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
                }
            },
            completion: nil)
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
            } else {
                // Swiped the shoppinglist separator
                return
            }
        }
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
            if item.amount != 1 && item.unit == nil{
                amountText = "\(item.amount)"
            } else if let unit = item.unit {
                amountText = "\(item.amount) \(unit.shortName)"
            }
            cell.amountLabel.text = amountText
            
            cell.nameLabel.text = item.name
            if item.isHighlited {
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
    
    // MARK: Actions
    
    func updateModifyDate () {
        let now = NSDate()
        shoppingList.lastModifiedDate = now
    }
    
    private func deleteItemAtIndexPath(indexPath: NSIndexPath) {
        let indexAndIndexPaths = getIndexAndIndexPathsForIndexPath(indexPath)
        let index = indexAndIndexPaths.index! // index != nil because the separator can't be swiped or edited
        let indexPaths = indexAndIndexPaths.indexPaths
        
        items.removeAtIndex(index)
        updateModifyDate()
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
        let itemParser = ItemParser()
        let item = itemParser.parseAmountAndUnit(quickAddTextField.text)
        quickAddTextField.text = ""
        quickAddButton.enabled = false
        addItem(item)
    }
    
    func addItem(item: Item) {
        let newIndexPath = NSIndexPath(forRow: notBoughtItems.count, inSection: 0)
        notBoughtItems.append(item)
        shoppingListTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        updateModifyDate()
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
                let item = Item(name: quickAddTextField.text)
                itemDetailsViewController.currentItem = item
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
        let text = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        checkValidItemName(text)
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // close keyboard when user taps on the view
        if closeKeyboardTapGestureRecognizer == nil {
            closeKeyboardTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "closeKeyboard")
        }
        view.addGestureRecognizer(closeKeyboardTapGestureRecognizer!)
    }
    
    func checkValidItemName(text: String) {
        // Disable the Save button if the text field is empty.
        quickAddButton.enabled = !text.isEmpty
    }
    
    deinit {
        shoppingListTableView.editing = false
    }

}