//
//  UnitDelegate.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 02.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation
import UIKit

class UnitDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var data : [Unit]
    
    private weak var pickerView : UIPickerView?
    private var plural = true
    var displayUnitNamesInPlural : Bool {
        get {
            return plural
        }
        set {
            let oldValue = plural
            plural = newValue
            if oldValue != newValue {
                pickerView?.reloadAllComponents()
            }
        }
    }
    
    var displayUnitNamesInSingular : Bool {
        get {
            return !plural
        }
        set {
            displayUnitNamesInPlural = !newValue
        }
    }
    
    init(pickerView: UIPickerView?) {
        self.pickerView = pickerView
        let unitHelper = UnitHelper.instance
        data = [unitHelper.BAG, unitHelper.BOTTLE, unitHelper.BOX, unitHelper.DOZEN, unitHelper.GRAM, unitHelper.KILOGRAM, unitHelper.LITRE, unitHelper.MILLILITRE, unitHelper.PACK, unitHelper.PIECE]
        super.init()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if plural {
            return data[row].name
        } else {
            return data[row].singularName
        }
    }
    
    /*func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int, inPlural: Bool) -> String? {
        if inPlural {
            return data[row].name
        } else {
            return data[row].singularName
        }
    }*/

}