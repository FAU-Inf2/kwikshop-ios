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
    static let AMOUNT_COMPONENT = 0
    static let UNIT_COMPONENT = 1
    private let AMOUNT_COMPONENT : Int = UnitAndAmountDelegate.AMOUNT_COMPONENT
    private let UNIT_COMPONENT : Int = UnitAndAmountDelegate.UNIT_COMPONENT
    private var selectedUnit = UnitHelper.instance.NONE
    
    override func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    override func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == AMOUNT_COMPONENT {
            if let indices = selectedUnit.allowedPickerIndices {
                return indices.count + 1
            }
            return UnitAndAmountDelegate.MAX_AMOUNT
        } else {
            return super.pickerView(pickerView, numberOfRowsInComponent: component)
        }
    }
    
    override func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == AMOUNT_COMPONENT {
            if row == 0 {
                return ""
            }
            if let indices = selectedUnit.allowedPickerIndices {
                return "\(indices[row - 1])"
            } else {
                return "\(row)"
            }
        } else {
            return super.pickerView(pickerView, titleForRow: row, forComponent: component)
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == AMOUNT_COMPONENT {
            if let indices = selectedUnit.allowedPickerIndices {
                if row == 0 {
                    self.displayUnitNamesInSingular = true
                } else {
                    self.displayUnitNamesInPlural = indices[row - 1] > 1
                }
            } else {
                self.displayUnitNamesInPlural = row > 1
            }

        } else if component == UNIT_COMPONENT {
            selectedUnit = super.data[row]
            pickerView.reloadAllComponents()
        }
    }
    
    func updateSelectedUnitInPickerView(pickerView: UIPickerView) {
        selectedUnit = super.data[pickerView.selectedRowInComponent(UNIT_COMPONENT)]
        pickerView.reloadAllComponents()
    }
}