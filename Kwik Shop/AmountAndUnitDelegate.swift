//
//  AmountAndUnitDelegate.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 29.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation

class AmountAndUnitDelegate : NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    static let AMOUNT_COMPONENT = 0
    static let UNIT_COMPONENT = 1
    private let AMOUNT_COMPONENT : Int = AmountAndUnitDelegate.AMOUNT_COMPONENT
    private let UNIT_COMPONENT : Int = AmountAndUnitDelegate.UNIT_COMPONENT
    private var UNIT_NONE : Unit {
        return UnitHelper.instance.NONE
    }

    private var lastSelectedAmount : Int?
    private var lastSelectedUnit : Unit = UnitHelper.instance.NONE
    
    let unitData : [Unit]
    
    override init() {
        let unitHelper = UnitHelper.instance
        unitData = [unitHelper.NONE, unitHelper.BAG, unitHelper.BOTTLE, unitHelper.BOX, unitHelper.DOZEN, unitHelper.GRAM, unitHelper.KILOGRAM, unitHelper.LITRE, unitHelper.MILLILITRE, unitHelper.PACK, unitHelper.PIECE]
        super.init()
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == AMOUNT_COMPONENT {
            let amounts = lastSelectedUnit.allowedPickerAmounts
            return amounts.count
        } else { // UNIT_COMPONENT
            return unitData.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let selectedUnit = unitData[pickerView.selectedRowInComponent(UNIT_COMPONENT)]
        if component == AMOUNT_COMPONENT {
            if let amount = selectedUnit.allowedPickerAmounts[row] {
                return "\(amount)"
            } else {
                // the amount in this row is nil
                return ""
            }
        } else { // UNIT_COMPONENT
            let selectedAmount : Int?
            let allowedAmounts = selectedUnit.allowedPickerAmounts
            let selectedAmountRow = pickerView.selectedRowInComponent(AMOUNT_COMPONENT)
            if selectedAmountRow < allowedAmounts.count {
                selectedAmount = selectedUnit.allowedPickerAmounts[pickerView.selectedRowInComponent(AMOUNT_COMPONENT)]
            } else {
                selectedAmount = 2 //the selected amount row index is greater than the max index -> the selected amount is plural
            }
            let unit = unitData[row]
            if isPlural(selectedAmount) {
                return unit.name
            } else {
                return unit.singularName
            }
        }
    }
    
    private func isPlural(amount: Int?) -> Bool{
        if amount == nil {
            return false
        }
        return amount != 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedUnit = unitData[pickerView.selectedRowInComponent(UNIT_COMPONENT)]
        if component == AMOUNT_COMPONENT {
            let oldAmount = lastSelectedAmount
            let newAmount = selectedUnit.allowedPickerAmounts[row]
            self.lastSelectedAmount = newAmount
            
            if isPlural(oldAmount) != isPlural(newAmount) {
                pickerView.reloadComponent(UNIT_COMPONENT)
            }
        } else { //UNIT_COMPONENT
            let oldUnit = lastSelectedUnit
            let newUnit = unitData[row]
            self.lastSelectedUnit = newUnit
            let oldType = oldUnit.allowedPickerIndexType
            let newType = newUnit.allowedPickerIndexType
            if oldType.rawValue != newType.rawValue {
                pickerView.reloadComponent(AMOUNT_COMPONENT)
                // the amount that is selected now might differ from the last selected amount, as the data changed
                let oldAmount = lastSelectedAmount
                let currentAmount = newUnit.allowedPickerAmounts[pickerView.selectedRowInComponent(AMOUNT_COMPONENT)]
                if oldAmount != currentAmount {
                    if oldAmount == nil {
                        // nil is not allowed anymore, so the amount "1" should be selected
                        // -> this works automatically at the moment, only the lastSelectedAmount has to be updated
                        self.lastSelectedAmount = 1
                    } else if currentAmount == nil {
                        // now nil is allowed, previously it was not
                        // -> the picker is at position 0 (amount nil) and should be at position 1 (amount 1)
                        pickerView.selectRow(1, inComponent: AMOUNT_COMPONENT, animated: false)
                    } else {
                        var amounts = selectedUnit.allowedPickerAmounts
                        var nonNilAmounts = [Int]()
                        for amount in amounts {
                            nonNilAmounts.append(amount ?? -1)
                        }
                        if let index = find(nonNilAmounts, oldAmount!) {
                            pickerView.selectRow(index, inComponent: AMOUNT_COMPONENT, animated: false)
                        } else {
                            // the amount that was selected before can't be selected for the current unit
                            pickerView.selectRow(0, inComponent: AMOUNT_COMPONENT, animated: true)
                        }
                    }
                } else {
                    return // the selected amount didn't change
                }
            } else {
                return // the same amounts are allowed as before, so no need to change anything
            }
        }
    }
    
    func selectAmount(amount: Int?, andUnit unit: Unit, forPickerView pickerView: UIPickerView, animated: Bool) {
        let unitRow = find(unitData, unit)!
        pickerView.selectRow(unitRow, inComponent: UNIT_COMPONENT, animated: animated)
        self.lastSelectedUnit = unit
        if amount == nil {
            // nil can only be the first amount (at the moment); if nil is not allowed, then "1" is selected (at index 0)
            pickerView.selectRow(0, inComponent: AMOUNT_COMPONENT, animated: animated)
        } else {
            var amounts = unit.allowedPickerAmounts
            var nonNilAmounts = [Int]()
            for amount in amounts {
                nonNilAmounts.append(amount ?? -1)
            }
            if let index = find(nonNilAmounts, amount!) {
                pickerView.selectRow(index, inComponent: AMOUNT_COMPONENT, animated: animated)
                self.lastSelectedAmount = amounts[index]
            } else {
                // the amount that should be selected can't be selected for the current unit
                pickerView.selectRow(0, inComponent: AMOUNT_COMPONENT, animated: animated)
                self.lastSelectedAmount = amounts[0]
            }
        }
    }
    
    func selectUnit(unit: Unit, forPickerView pickerView: UIPickerView, animated: Bool) {
        let unitRow = find(unitData, unit)!
        pickerView.selectRow(unitRow, inComponent: UNIT_COMPONENT, animated: animated)
        self.lastSelectedUnit = unit
    }
    
    func getSelectedAmount() -> Int? {
        return lastSelectedAmount
    }
}