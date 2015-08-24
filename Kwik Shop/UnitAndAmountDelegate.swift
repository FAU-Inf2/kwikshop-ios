//
//  UnitAndAmountDelegate.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 24.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation
import UIKit

class UnitAndAmountDelegate: UnitDelegate {
    
    static let MAX_AMOUNT = 10000
    
    override func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    override func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return UnitAndAmountDelegate.MAX_AMOUNT
        } else {
            return super.pickerView(pickerView, numberOfRowsInComponent: component)
        }
    }
    
    override func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            if row == 0 {
                return ""
            } else {
                return "\(row)"
            }
        } else {
            return super.pickerView(pickerView, titleForRow: row, forComponent: component)
        }
    }
}