//
//  GroupDelegate.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 01.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation
import UIKit

class GroupDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var data : [String]
    
    override init() {
        data = ["Hello", "Hi", "Huhu", "Huhuh"]
        super.init()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return NSLocalizedString(data[row], tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
}