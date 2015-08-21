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
    
    var data : [Group]
    
    override init() {
        let groupHelper = GroupHelper.instance
        data = [groupHelper.OTHER, groupHelper.BABY_FOODS, groupHelper.BEVERAGES, groupHelper.BREAK_PASTRIES, groupHelper.DAIRY, groupHelper.FROZEN_AND_CONVENIENCE, groupHelper.FRUITS_AND_VEGETABLES, groupHelper.HEALTH_AND_HYGIENE, groupHelper.HOUSEHOLD, groupHelper.INGREDIENTS_AND_SPICES, groupHelper.MEAT_AND_FISH, groupHelper.PASTA, groupHelper.PET_SUPPLIES, groupHelper.SWEETS_AND_SNACKS, groupHelper.TOBACCO, groupHelper.COFFEE_AND_TEA]
        
        super.init()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row].name
    }
}