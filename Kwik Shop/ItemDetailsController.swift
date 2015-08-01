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
    @IBOutlet weak var groupLabel: NSLayoutConstraint!
    @IBOutlet weak var groupPicker: UIPickerView!
    
    var groupDelegate : GroupDelegate?
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        if groupDelegate == nil {
            groupDelegate = GroupDelegate()
        }
        groupPicker.delegate = groupDelegate
        groupPicker.dataSource = groupDelegate
    }
    
    // MARK: Actions
}
