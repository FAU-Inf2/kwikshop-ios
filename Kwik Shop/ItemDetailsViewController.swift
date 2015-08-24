//
//  ItemDetailsController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 29.07.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class ItemDetailsViewController : UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate, MLPAutoCompleteTextFieldDataSource {
    // MARK: Properties
    @IBOutlet weak var itemNameTextField: MLPAutoCompleteTextField!
    @IBOutlet weak var amountLabel: UILabel!    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var unitPicker: UIPickerView!
    @IBOutlet weak var highlightLabel: UILabel!
    @IBOutlet weak var highlightSwitch: UISwitch!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var brandTextField: MLPAutoCompleteTextField!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var groupPicker: UIPickerView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewToolbarConstraint: NSLayoutConstraint!
    
    
    var groupDelegate : GroupDelegate!
    var unitDelegate : UnitDelegate!
    
    var currentItem : Item?
    var newItem = true
    
    private var unitHasChanged = false
    private var groupHasChanged = false
    
    private let autoCompletionHelper = AutoCompletionHelper.instance
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        if groupDelegate == nil {
            groupDelegate = GroupDelegate()
            groupPicker.delegate = self
            groupPicker.dataSource = self
        }
        if unitDelegate == nil {
            unitDelegate = UnitDelegate(pickerView: unitPicker)
            unitPicker.delegate = self
            unitPicker.dataSource = self
        }
        
        if let primaryColor = UIColor(resourceName: "primary_color") {
            highlightSwitch.onTintColor = primaryColor
        }
        
        self.hideToolbar(newItem)
        
        if newItem {
            if let item = currentItem {
                itemNameTextField.text = item.name
                
                if let amount = item.amount {
                    amountTextField.text = "\(amount)"
                }
                unitDelegate.displayUnitNamesInSingular = isThisSingular(amountTextField.text)
                
                if let unit = item.unit {
                    selectUnit(unit, animated: false)
                } else if let unit = autoCompletionHelper.getUnitForItem(item) {
                    selectUnit(unit, animated: false)
                }
                
                if let group = autoCompletionHelper.getGroupForItem(item) {
                    selectGroup(group, animated: false)
                }
            }
        } else if let item = currentItem {
            itemNameTextField.text = item.name
            if let amount = item.amount {
                amountTextField.text = "\(amount)"
            }
            unitDelegate.displayUnitNamesInSingular = isThisSingular(amountTextField.text)
            
            if let unit = item.unit, row = find(unitDelegate.data, unit) {
                unitPicker.selectRow(row, inComponent: 0, animated: false)
            }
            
            highlightSwitch.setOn(item.highlighted, animated: false)
            if let brand = item.brand {
                brandTextField.text = brand
            }
            if let comment = item.comment {
                commentTextField.text = comment
            }
            
            if let group = item.group, row = find(groupDelegate.data, group) {
                groupPicker.selectRow(row, inComponent: 0, animated: false)
            }

        } else {
            assertionFailure("Item details was loaded with newItem set to false but currentItem set to nil")
        }
        
        itemNameTextField.delegate = self
        initializeAutoCompletionTextField(itemNameTextField)
        
        checkValidItemName(itemNameTextField.text)
        amountTextField.delegate = self
        commentTextField.delegate = self
        
        brandTextField.delegate = self
        initializeAutoCompletionTextField(brandTextField)
        
        // close keyboard when user taps on the view
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "closeKeyboard")
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        highlightSwitch.addTarget(self, action: "closeKeyboard", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    private func initializeAutoCompletionTextField(textField: MLPAutoCompleteTextField) {
        textField.autoCompleteDataSource = self
        textField.autoCompleteTableBackgroundColor = UIColor.whiteColor()
        textField.showAutoCompleteTableWhenEditingBegins = true
        
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        if orientation == .LandscapeLeft || orientation == .LandscapeRight {
            textField.maximumNumberOfAutoCompleteRows = 3
        } else {
            textField.maximumNumberOfAutoCompleteRows = 5
        }
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        let orientation = toInterfaceOrientation
        if orientation == .LandscapeLeft || orientation == .LandscapeRight {
            itemNameTextField.maximumNumberOfAutoCompleteRows = 3
            brandTextField.maximumNumberOfAutoCompleteRows = 3
        } else {
            itemNameTextField.maximumNumberOfAutoCompleteRows = 5
            brandTextField.maximumNumberOfAutoCompleteRows = 5
        }
        itemNameTextField.autoCompleteTableViewHidden = true
        brandTextField.autoCompleteTableViewHidden = true
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        itemNameTextField.autoCompleteTableViewHidden = false
        brandTextField.autoCompleteTableViewHidden = false
    }
    
    private func selectUnit(unit: Unit, animated: Bool) {
        if let row = find(unitDelegate.data, unit) {
            unitPicker.selectRow(row, inComponent: 0, animated: animated)
            unitHasChanged = true
        }
    }
    
    private func selectGroup(group: Group, animated: Bool) {
        if let row = find(groupDelegate.data, group) {
            groupPicker.selectRow(row, inComponent: 0, animated: animated)
            groupHasChanged = true
        }
    }
   
    override func viewDidAppear(animated: Bool) {
        if (newItem && currentItem == nil) {
            itemNameTextField.becomeFirstResponder()
        }
    }
    
    func checkValidItemName(text: String) {
        // Disable the Save button if the text field is empty.
        saveButton.enabled = !text.isEmpty
    }
    
    // needs to be called at least once, otherwise the layout might be broken
    private func hideToolbar(hide : Bool) {
        toolBar.hidden=hide
        scrollViewBottomConstraint.active = hide
        scrollViewToolbarConstraint.active = !hide
    }
    
    func closeKeyboard() {
        itemNameTextField.resignFirstResponder()
        amountTextField.resignFirstResponder()
        brandTextField.resignFirstResponder()
        commentTextField.resignFirstResponder()
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    /*func textFieldDidBeginEditing(textField: UITextField) {
        if (textField === itemNameTextField) {
            // Disable the Save button while editing.
            saveButton.enabled = false
        }
    }*/
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (textField === itemNameTextField) {
            let name = itemNameTextField.text
            checkValidItemName(name)
            navigationItem.title = name
            if newItem {
                if !unitHasChanged {
                    if let unit = autoCompletionHelper.getUnitForName(name) {
                        selectUnit(unit, animated: true)
                    }
                }
                if !groupHasChanged {
                    if let group = autoCompletionHelper.getGroupForName(name) {
                        selectGroup(group, animated: true)
                    }
                }
            }
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField === amountTextField {
            let digits : [Character] = ["0","1","2","3","4","5","6","7","8","9"]
            for char in string {
                if !contains(digits, char) {
                    return false
                }
            }
            let newText = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            unitDelegate.displayUnitNamesInSingular = isThisSingular(newText)
            
            return true
        } else if textField === itemNameTextField {
            let text = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
            checkValidItemName(text)
            return true
        } else {
            return true
        }
    }
    
    private func isThisSingular (text: String) -> Bool {
        return text.isEmpty || text == "1"
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
        if touch.view.isDescendantOfView(itemNameTextField.autoCompleteTableView) || touch.view.isDescendantOfView(brandTextField.autoCompleteTableView) {
            // autocomplete suggestion was tapped
            return false;
        }
        // somewhere else was tapped
        return true;
    }
    
    // MARK: Navigation
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
            var refreshAlert = UIAlertController(title: nil, message: "Are you sure you want to delete this item?", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            refreshAlert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { [unowned self, weak deleteButton = self.deleteButton] (action: UIAlertAction!) in
                self.performSegueWithIdentifier("unwindToShoppingList", sender: deleteButton)
            }))
            
            /*refreshAlert.addAction(UIAlertAction(title: "Continue and don't ask again", style: .Default, handler: { [unowned self, weak deleteButton = self.deleteButton] (action: UIAlertAction!) in
                // TODO: Perform logic to avoid asking again
                self.performSegueWithIdentifier("unwindToShoppingList", sender: deleteButton)
            }))*/
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
                return
            }))
            
            presentViewController(refreshAlert, animated: true, completion: nil)
            
            return false
        }
        return true
    }
    
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let name = itemNameTextField.text
            let amount : Int?
            if let convertedAmount = amountTextField.text.toInt() {
                amount = convertedAmount
            } else {
                amount = nil
            }
            
            let unit : Unit?
            if unitHasChanged {
                let unitIndex = unitPicker.selectedRowInComponent(0)
                unit = unitDelegate.data[unitIndex]
            } else {
                unit = currentItem?.unit
            }
            
            let highlighted = highlightSwitch.on
            let brand = brandTextField.text
            let comment = commentTextField.text
            // TODO: Group has to be stored
            let group : Group?
            if groupHasChanged {
                let groupIndex = groupPicker.selectedRowInComponent(0)
                group = groupDelegate.data[groupIndex]
            } else {
                group = currentItem?.group
            }

            
            if currentItem == nil {
                currentItem = Item(name: name, amount: amount, unit: unit, highlighted: highlighted, brand: brand, comment: comment, group: group)
            } else {
                currentItem!.name = name
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
    
    // MARK: PickerView Delegate and Data Source
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        let delegate : UIPickerViewDataSource
        if pickerView === unitPicker {
            delegate = self.unitDelegate
        } else if pickerView === groupPicker {
            delegate = self.groupDelegate
        } else {
            return 0
        }
        return delegate.numberOfComponentsInPickerView(pickerView)
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let delegate : UIPickerViewDataSource
        if pickerView === unitPicker {
            delegate = self.unitDelegate
        } else if pickerView === groupPicker {
            delegate = self.groupDelegate
        } else {
            return 0
        }
        return delegate.pickerView(pickerView, numberOfRowsInComponent: component)

    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let delegate : UIPickerViewDelegate
        if pickerView === unitPicker {
            delegate = self.unitDelegate
        } else if pickerView === groupPicker {
            delegate = self.groupDelegate
        } else {
            return nil
        }
        return delegate.pickerView?(pickerView, titleForRow: row, forComponent: component)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView === unitPicker {
            unitHasChanged = true
        } else if pickerView === groupPicker {
            groupHasChanged = true
        }
        closeKeyboard()
    }
    
    // MARK: Actions
}
