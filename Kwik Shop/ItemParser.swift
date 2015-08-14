//
//  ItemParser.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 14.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation

class ItemParser {
    
    func parseAmountAndUnit(input : String) -> Item {
        var output = ""
        var amount = ""
        var thisCanBeUnitOrName = ""
        var lastCharWasANumber = false
        var charWasReadAfterAmount = false
        var emptyStringOrWhiteSpace = true
        
        for char in input {
            // only parse the first number found to amount
            if char >= "0" && char <= "9" && (lastCharWasANumber || amount.isEmpty) && emptyStringOrWhiteSpace {
                amount.append(char)
                lastCharWasANumber = true
            } else if lastCharWasANumber && char == " " {
                // ignore all white spaces between the amount and the next char
                emptyStringOrWhiteSpace = true
            } else if lastCharWasANumber || charWasReadAfterAmount && char != " " {
                //String from amount to next whitespace, this should be unit or name
                thisCanBeUnitOrName.append(char)
                lastCharWasANumber = false
                charWasReadAfterAmount = true
                emptyStringOrWhiteSpace = false
            } else if charWasReadAfterAmount && char == " " {
                //whitespace after possible unit
                charWasReadAfterAmount = false
                emptyStringOrWhiteSpace = true
            } else if char == " " {
                emptyStringOrWhiteSpace = true
                output.append(char)
            } else {
                output.append(char)
                lastCharWasANumber = false
                emptyStringOrWhiteSpace = false
            }
        }
        
        var unitMatchFound = false
        var foundUnit : Unit? = nil
        var foundAmount : Int? = nil
        let unitDelegate = UnitDelegate()
        
        for unit in unitDelegate.data {
            if unit.name.localized.caseInsensitiveCompare(thisCanBeUnitOrName) == .OrderedSame || unit.shortName.caseInsensitiveCompare(thisCanBeUnitOrName) == .OrderedSame {
                foundUnit = unit
                unitMatchFound = true
                break
            }
        }
        
        if !unitMatchFound && !thisCanBeUnitOrName.isEmpty {
            //if no unit was found complete string has to be restored
            if output.isEmpty {
                output = thisCanBeUnitOrName;
            } else {
                output = thisCanBeUnitOrName + " " + output;
            }
        }
        
        if !(output.isEmpty || emptyStringOrWhiteSpace) {
            if amount != "" {
                foundAmount = amount.toInt()
            }
        }
        
        let string = NSMutableString(string: output)
        CFStringTrimWhitespace(string)
        
        let item = Item(name: string as String)
        if let itemAmount = foundAmount {
            item.amount = itemAmount
        }
        if let itemUnit = foundUnit {
            item.unit = foundUnit
        }
        
        return item
    }
    
}
