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
    
    var data = ["unit_bag", "unit_bottle", "unit_box", "unit_dozen", "unit_gram", "unit_kilogram", "unit_litre", "unit_millilitre",  "unit_pack", "unit_piece"]
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row].localized
    }
}