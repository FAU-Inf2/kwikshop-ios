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
        var myDict: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource("Colors", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        if let dict = myDict, rgb = dict["primary_Color"] as? [Int] {
            let red = CGFloat(rgb[0])/255
            let green = CGFloat(rgb[1])/255
            let blue = CGFloat(rgb[2])/255
            let kwikShopGreen = UIColor(red: red, green: green, blue: blue, alpha: 1)
            navigationController?.navigationBar.barTintColor = kwikShopGreen
            cancelButton.tintColor = UIColor.whiteColor()
            saveButton.tintColor = UIColor.whiteColor()
        }
    }
    
    // MARK: Actions
}
