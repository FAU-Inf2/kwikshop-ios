//
//  AlternativeItemDetailsViewController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 02.09.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class AlternativeItemDetailsViewController: AutoCompletionViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, MLPAutoCompleteTextFieldDataSource {
    
    // MARK: Properties
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var itemDetailsTableView: UITableView!
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    weak var closeKeyboardTapGestureRecognizer: UITapGestureRecognizer!
    weak var itemNameTextField: MLPAutoCompleteTextField?
    weak var brandTextField: MLPAutoCompleteTextField?
    weak var commentTextField: UITextField?

    var currentItem : Item?
    var newItem = true
    
    private var unitHasChanged = false
    private var groupHasChanged = false
    
    private let autoCompletionHelper = AutoCompletionHelper.instance
    
    var currentItemName : String?
    var currentAmount : Int?
    var currentUnit = UnitHelper.instance.NONE
    var currentlyHighlighted = false
    var currentBrand : String?
    var currentComment : String?
    var currentGroup = GroupHelper.instance.OTHER
    
    private let ITEM_NAME_INDEX = 0
    private let AMOUNT_INDEX = 1
    private let HIGHLIGHT_INDEX = 2
    private let BRAND_INDEX = 3
    private let COMMENT_INDEX = 4
    private let GROUP_INDEX = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemDetailsTableView.dataSource = self
        itemDetailsTableView.delegate = self
        itemDetailsTableView.estimatedRowHeight = 44.0
        itemDetailsTableView.rowHeight = UITableViewAutomaticDimension
        
        // close keyboard when user taps on the view
        if self.closeKeyboardTapGestureRecognizer == nil {
            let tapRecognizer = UITapGestureRecognizer(target: self, action: "closeKeyboard")
            tapRecognizer.delegate = self
            view.addGestureRecognizer(tapRecognizer)
            self.closeKeyboardTapGestureRecognizer = tapRecognizer
        }
        
        self.bottomViewLayoutConstraint = toolbarBottomConstraint
        self.bottomViewLayoutConstraintDefaultConstant = 0
        
        if newItem {
            if let item = currentItem {
                currentItemName = item.name
                let unit = item.unit
                let none = UnitHelper.instance.NONE
                let unitToSelect : Unit
                if unit !== none {
                    unitToSelect = unit
                } else if let unit = autoCompletionHelper.getUnitForItem(item) {
                    unitToSelect = unit
                } else {
                    unitToSelect = none
                }
                currentUnit = unitToSelect
                currentGroup = autoCompletionHelper.getGroupForItem(item)
                
                if let visibleRows = itemDetailsTableView.indexPathsForVisibleRows() {
                    itemDetailsTableView.reloadRowsAtIndexPaths(visibleRows, withRowAnimation: .None)
                }
            } else {
                // item details view is opened for a completely new item
            }
        } else if let item = currentItem {
            currentItemName = item.name
            currentAmount = item.amount
            currentUnit = item.unit
            currentlyHighlighted = item.highlighted
            currentBrand = item.brand
            currentComment = item.comment
            currentGroup = item.group
            
            if let visibleRows = itemDetailsTableView.indexPathsForVisibleRows() {
                itemDetailsTableView.reloadRowsAtIndexPaths(visibleRows, withRowAnimation: .None)
            }
        } else {
            assertionFailure("Item details was loaded with newItem set to false but currentItem set to nil")
        }
    }

    override func viewWillAppear(animated: Bool) {
        if let indexPath = itemDetailsTableView.indexPathForSelectedRow() {
            itemDetailsTableView.deselectRowAtIndexPath(indexPath, animated: animated)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if (newItem && currentItem == nil) {
            itemNameTextField?.becomeFirstResponder()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegate and DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case ITEM_NAME_INDEX:
            let cell = tableView.dequeueReusableCellWithIdentifier("itemNameCell", forIndexPath: indexPath) as! ItemNameTableViewCell
            
            if self.itemNameTextField == nil {
                self.itemNameTextField = cell.itemNameTextField
                self.itemNameTextField!.delegate = self
                initializeAutoCompletionTextField(self.itemNameTextField!, withDataSource: self)
            }
            
            if let itemName = currentItemName {
                cell.itemNameTextField.text = itemName
            }
            return cell
            
        case AMOUNT_INDEX:
            let cell = tableView.dequeueReusableCellWithIdentifier("amountCell", forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = "item_details_amount".localized
            var amountText = ""
            let singularAmount = isThisSingular(currentAmount)
            if let amount = currentAmount {
                amountText += "\(amount)"
            }
            if singularAmount && !currentUnit.shortestPossibleSingularDescription.isEmpty {
                amountText += " \(currentUnit.shortestPossibleSingularDescription)"
            } else if !singularAmount && !currentUnit.shortestPossibleDescription.isEmpty {
                amountText += " \(currentUnit.shortestPossibleDescription)"
            }
            
            cell.detailTextLabel?.text = amountText
            return cell
            
        case HIGHLIGHT_INDEX:
            let cell = tableView.dequeueReusableCellWithIdentifier("highlightCell", forIndexPath: indexPath) as! HighlightTableViewCell
            cell.highlightLabel.text = "item_details_highlight".localized
            cell.highlightSwitch.on = currentlyHighlighted
            if let primaryColor = UIColor(resourceName: "primary_color") {
                cell.highlightSwitch.onTintColor = primaryColor
            }
            return cell
            
        case BRAND_INDEX:
            let cell = tableView.dequeueReusableCellWithIdentifier("brandCell", forIndexPath: indexPath) as! BrandTableViewCell
            cell.brandLabel.text = "item_details_brand".localized
            if self.brandTextField == nil {
                self.brandTextField = cell.brandTextField
                self.brandTextField!.delegate = self
                initializeAutoCompletionTextField(self.brandTextField!, withDataSource: self)
            }
            if let brand = currentBrand {
                cell.brandTextField.text = brand
            }
            return cell
        
        case COMMENT_INDEX:
            let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentTableViewCell
            cell.commentLabel.text = "item_details_comment".localized
            if self.commentTextField == nil {
                self.commentTextField = cell.commentTextField
                self.commentTextField!.delegate = self
            }
            if let comment = currentComment {
                cell.commentTextField.text = comment
            }
            return cell
        
        default: // GROUP_INDEX:
            let cell = tableView.dequeueReusableCellWithIdentifier("groupCell", forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = "item_details_group".localized
            cell.detailTextLabel?.text = currentGroup.name
            return cell
        }
    }
    
    // MARK: Textfield
    
    func checkValidItemName(text: String) {
        // Disable the Save button if the text field is empty.
        saveButton.enabled = !text.isEmpty
    }
    
    func closeKeyboard() {
        itemNameTextField?.resignFirstResponder()
        brandTextField?.resignFirstResponder()
        commentTextField?.resignFirstResponder()
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (textField === itemNameTextField) {
            let name = itemNameTextField!.text
            self.currentItemName = name
            checkValidItemName(name)
            navigationItem.title = name
            if newItem {
                if !unitHasChanged {
                    if let unit = autoCompletionHelper.getUnitForName(name) {
                        selectUnit(unit, animated: true)
                    }
                }
                if !groupHasChanged {
                    let group = autoCompletionHelper.getGroupForName(name)
                    selectGroup(group, animated: true)
                }
            }
        } else if (textField === brandTextField) {
            let brand = textField.text
            if brand.isEmpty {
                self.currentBrand = nil
            } else {
                self.currentBrand = brand
            }
        } else if (textField === commentTextField) {
            let comment = textField.text
            if comment.isEmpty {
                self.currentComment = nil
            } else {
                self.currentComment = comment
            }
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField === itemNameTextField {
            let text = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
            checkValidItemName(text)
            return true
        } else {
            return true
        }
    }

    // MARK: MLP Autocompletion
    func autoCompleteTextField(textField: MLPAutoCompleteTextField!, possibleCompletionsForString string: String!) -> [AnyObject]! {
        if textField === self.itemNameTextField {
            return autoCompletionHelper.possibleCompletionsForItemName(string)
        }
        if textField === self.brandTextField {
            return autoCompletionHelper.possibleCompletionsForBrand(string)
        }
        return [AnyObject]()
    }
    
    // MARK: UIGestureRecognizerDelegate
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if (itemNameTextField != nil && touch.view.isDescendantOfView(itemNameTextField!.autoCompleteTableView)) || (brandTextField != nil && touch.view.isDescendantOfView(brandTextField!.autoCompleteTableView)) {
            // autocomplete suggestion was tapped
            return false;
        }
        // somewhere else was tapped
        return true;
    }

    // MARK: Actions
    @IBAction func highlightSwichChanged(sender: UISwitch) {
        self.currentlyHighlighted = sender.on
    }
    
    private func selectGroup(group: Group, animated: Bool) {
        self.currentGroup = group
        let animation = animated ? UITableViewRowAnimation.Automatic : UITableViewRowAnimation.None
        itemDetailsTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: GROUP_INDEX, inSection: 0)], withRowAnimation: animation)
    }
    
    private func selectUnit(unit: Unit, animated: Bool) {
        self.currentUnit = unit
        let animation = animated ? UITableViewRowAnimation.Automatic : UITableViewRowAnimation.None
        itemDetailsTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: AMOUNT_INDEX, inSection: 0)], withRowAnimation: animation)
    }
    
    private func isThisSingular (amount: Int?) -> Bool {
        return amount == nil || amount == 1
    }
    
    // MARK: - Navigation

    @IBAction func cancel(sender: UIBarButtonItem) {
        if newItem {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        // if a confirmation dialoge should be displayed before the item is deleted: here is the place to do so
        if sender === deleteButton {
            let alert = DeleteConfirmationAlertHelper.getDeleteConfirmationAlertWithDeleteHandler(
                { [unowned self, weak deleteButton = self.deleteButton] (action: UIAlertAction!) in
                    self.performSegueWithIdentifier("unwindToShoppingList", sender: deleteButton)
                },
                forASingularValue: true)
            alert.popoverPresentationController?.barButtonItem = deleteButton
            self.presentViewController(alert, animated: true, completion: nil)
            
            return false
        }
        return true
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let name = currentItemName
            let amount = currentAmount
            let unit = currentUnit
            let highlighted = currentlyHighlighted
            let brand = currentBrand
            let comment = currentComment
            let group = currentGroup
            
            if currentItem == nil {
                currentItem = Item(name: name!, amount: amount, unit: unit, highlighted: highlighted, brand: brand, comment: comment, group: group)
            } else {
                currentItem!.name = name!
                currentItem!.amount = amount
                currentItem!.unit = unit
                currentItem!.highlighted = highlighted
                currentItem!.brand = brand
                currentItem!.comment = comment
                currentItem!.group = group
            }
        } else if deleteButton === sender {
            currentItem = nil
        }
    }
    

}
