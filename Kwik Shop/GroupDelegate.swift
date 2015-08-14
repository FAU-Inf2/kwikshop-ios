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
    
    var data = [Group.OTHER, Group.BABY_FOODS, Group.BEVERAGES, Group.BREAK_PASTRIES, Group.DAIRY, Group.FROZEN_AND_CONVENIENCE, Group.FRUITS_AND_VEGETABLES, Group.HEALTH_AND_HYGIENE, Group.HOUSEHOLD, Group.INGREDIENTS_AND_SPICES, Group.MEAT_AND_FISH, Group.PASTA, Group.PET_SUPPLIES, Group.SWEETS_AND_SNACKS, Group.TOBACCO, Group.COFFEE_AND_TEA]
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //return NSLocalizedString(data[row], tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
        return data[row].name.localized
    }
}