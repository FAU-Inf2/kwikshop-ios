//
//  ItemDetailsController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 29.07.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class ItemDetailsController : UIViewController {
    // MARK: Properties
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var amountLabel: UILabel!    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var unitPicker: UIPickerView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var groupPicker: UIPickerView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var groupDelegate : GroupDelegate?
    var unitDelegate : UnitDelegate?
    
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
        //navigationController?.navigationBar.barTintColor = UIColor.greenColor()
        navigationController?.navigationBar.barTintColor = UIColor(red: 0x00/255, green: 0x89/255, blue: 0x7b/255, alpha: 1)
        cancelButton.tintColor = UIColor.whiteColor()
        saveButton.tintColor = UIColor.whiteColor()
    }
    
    // MARK: Actions
}
