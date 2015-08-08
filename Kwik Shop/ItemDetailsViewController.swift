//
//  ItemDetailsController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 29.07.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class ItemDetailsViewController : UIViewController {
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
    
    
    var groupDelegate : GroupDelegate?
    var unitDelegate : UnitDelegate?
    
    var currentItem : Item?
    var newItem = true
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        if groupDelegate == nil {
            groupDelegate = GroupDelegate()
            groupPicker.delegate = groupDelegate
            groupPicker.dataSource = groupDelegate
        }
        if unitDelegate == nil {
            unitDelegate = UnitDelegate()
            unitPicker.delegate = unitDelegate
            unitPicker.dataSource = unitDelegate
        }
        
        if let primaryColor = UIColor(resourceName: "primary_color") {
            highlightSwitch.onTintColor = primaryColor
        }
        
        self.hideToolbar(newItem)
        
        if newItem {
            saveButton.enabled = false
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
    }
    
    // needs to be called at least once, otherwise the layout might be broken
    private func hideToolbar(hide : Bool) {
        toolBar.hidden=hide
        scrollViewBottomConstraint.active = hide
        scrollViewToolbarConstraint.active = !hide
    }
    
    // MARK: Navigation
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Actions
}
