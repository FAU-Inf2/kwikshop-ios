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
        data = ["group_other", "group_babyFoods", "group_beverages", "group_breakPastries", "group_dairy", "group_frozenAndConvenience", "group_fruitsAndVegetables", "group_healthAndHygiene", "group_household", "group_ingredientsAndSpices", "group_meatAndFish", "group_pasta", "group_petSupplies", "group_sweetsAndSnacks", "group_tobacco", "group_coffeeAndTea"]
        super.init()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        //return NSLocalizedString(data[row], tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
        return data[row].localized
    }
}