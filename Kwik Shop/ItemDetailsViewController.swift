//
//  ItemDetailsController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 29.07.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class ItemDetailsViewController : UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: Properties
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var amountLabel: UILabel!    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var unitPicker: UIPickerView!
    @IBOutlet weak var highlightLabel: UILabel!
    @IBOutlet weak var highlightSwitch: UISwitch!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var brandTextField: UITextField!
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
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        if groupDelegate == nil {
            groupDelegate = GroupDelegate()
            groupPicker.delegate = self
            groupPicker.dataSource = self
        }
        if unitDelegate == nil {
            unitDelegate = UnitDelegate()
            unitPicker.delegate = self
            unitPicker.dataSource = self
        }
        
        if let primaryColor = UIColor(resourceName: "primary_color") {
            highlightSwitch.onTintColor = primaryColor
        }
        
        self.hideToolbar(newItem)
        
        if newItem {
            // do nothing (yet)
        } else if let item = currentItem {
            itemNameTextField.text = item.name
            amountTextField.text = "\(item.amount)"
            //unitPicker has to select unit
            highlightSwitch.setOn(item.isHighlited, animated: false)
            if let brand = item.brand {
                brandTextField.text = brand
            }
            if let comment = item.comment {
                commentTextField.text = comment
            }
            //groupPicker has to select group
        } else {
            assertionFailure("Item details was loaded with newItem set to false but currentItem set to nil")
        }
        
        itemNameTextField.delegate = self
        checkValidItemName()
        amountTextField.delegate = self
        commentTextField.delegate = self
        brandTextField.delegate = self
        
        // close keyboard when user taps on the view
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "closeKeyboard")
        view.addGestureRecognizer(tapGesture)
        highlightSwitch.addTarget(self, action: "closeKeyboard", forControlEvents: UIControlEvents.ValueChanged)

    }
    
    
    func checkValidItemName() {
        // Disable the Save button if the text field is empty.
        let text = itemNameTextField.text ?? ""
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField === itemNameTextField) {
            // Disable the Save button while editing.
            saveButton.enabled = false
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (textField === itemNameTextField) {
            checkValidItemName()
            navigationItem.title = textField.text
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
            return true
        } else {
            return true
        }
    }
    
    // MARK: Navigation
    @IBAction func cancel(sender: UIBarButtonItem) {
        if newItem {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let name = itemNameTextField.text
            let amount : Int
            if let convertedAmount = amountTextField.text.toInt() {
                amount = convertedAmount
            } else {
                amount = 1
            }
            // TODO: Unit has to be stored
            let unit : Unit? = nil
            let highlight = highlightSwitch.on
            let brand = brandTextField.text
            let comment = commentTextField.text
            // TODO: Group has to be stored
            let group : Group? = nil
            currentItem = Item(name: name, amount: amount, unit: unit, highlight: highlight, brand: brand, comment: comment, group: group)
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
        closeKeyboard()
    }
    
    // MARK: Actions
}
