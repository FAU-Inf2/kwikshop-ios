//
//  ItemParser.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 14.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation

class ItemParser {
    
    let autoCompletionHelper = AutoCompletionHelper.instance
    
    func getNameAmountAndUnitForInput(input: String) -> (name: String?, amount: Int?, unit: Unit?)? {
        let wordsWithEmptyWords = input.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        let words = wordsWithEmptyWords.filter({return !$0.isEmpty})
        
        let count = words.count
        
        if count == 0 {
            return nil
        }
        
        let first = words.first!
        if let amount = first.toInt() {
            // amount found in the first word
            if count == 1 {
                return (nil, amount, nil) // only amount was entered
            }
            let second = words[1] // this can be either the unit or no unit was specified and everything else is the item name
            let unit = findUnitForString(second, withAmountSpecified: amount)
            
            if count == 2 {
                if unit == nil {
                    return (second, amount, nil)
                } else {
                    return (nil, amount, unit)
                }
            }
            
            var itemName : String
            if unit == nil {
                itemName = "\(second) "
            } else {
                itemName = ""
            }
            
            for index in 2 ..< count {
                if index == count - 1 {
                    // last word
                    itemName += words[index]
                } else {
                    itemName += "\(words[index]) "
                }
            }
            return (itemName, amount, unit)
        }
        
        if count > 1 {
            if let amount = words.last!.toInt() {
                // amount found in the last word
                var itemName = ""
                for index in 0 ..< count - 1 {
                    if index == count - 2 {
                        // last word before amount
                        itemName += words[index]
                    } else {
                        itemName += "\(words[index]) "
                    }
                }
                return (itemName, amount, nil)
            }
        }
        
        if count > 2 {
            if let amount = words[count - 2].toInt() {
                // amount found in the second last word, if last word is unit, this is ok
                if let unit = findUnitForString(words.last!, withAmountSpecified: amount) {
                    // amount and unit are the last two words
                    var itemName = ""
                    for index in 0 ..< count - 2 {
                        if index == count - 3 {
                            // last word before amount
                            itemName += words[index]
                        } else {
                            itemName += "\(words[index]) "
                        }
                    }
                    return (itemName, amount, unit)
                }
            }
        }
        
        // no amount found
        
        let unit = findUnitForString(first, withAmountSpecified: nil)
        
        if count == 1 {
            if unit == nil {
                return (first, nil, nil)
            } else {
                return (nil, nil, unit)
            }
        }
        
        var itemName : String
        if unit == nil {
            itemName = "\(first) "
        } else {
            itemName = ""
        }
        
        for index in 1 ..< count {
            if index == count - 1 {
                // last word
                itemName += words[index]
            } else {
                itemName += "\(words[index]) "
            }
        }
        return (itemName, nil, unit)
    }
    
    private func findUnitForString(possibleUnit: String, withAmountSpecified amountSpecified: Int?) -> Unit? {
        let unitDelegate = AmountAndUnitDelegate()
        if let amount = amountSpecified {
            if amount > 1 {
                // the amount is plural
                for unit in unitDelegate.unitData {
                    if unit.shortestPossibleDescription.caseInsensitiveCompare(possibleUnit) == .OrderedSame || unit.name.caseInsensitiveCompare(possibleUnit) == .OrderedSame {
                        return unit
                    }
                }
                return nil
            } else {
                // the amount is singular
                for unit in unitDelegate.unitData {
                    if unit.shortestPossibleSingularDescription.caseInsensitiveCompare(possibleUnit) == .OrderedSame || unit.singularName.caseInsensitiveCompare(possibleUnit) == .OrderedSame {
                        return unit
                    }
                }
                return nil
            }
        } else {
            // the amount is not specified
            for unit in unitDelegate.unitData {
                if unit.shortestPossibleSingularDescription.caseInsensitiveCompare(possibleUnit) == .OrderedSame || unit.singularName.caseInsensitiveCompare(possibleUnit) == .OrderedSame {
                    return unit
                }
            }
            return nil
        }
    }
    
    func getItemForParsedAmountAndUnit(nameAmountAndUnit: (name: String?, amount: Int?, unit: Unit?)?) -> Item? {
        if let name = nameAmountAndUnit?.name {
            
            if name.isEmpty {
                return nil
            }
            
            let item = Item(name: name)
            if let itemAmount = nameAmountAndUnit!.amount {
                item.amount = itemAmount
            }
            if let itemUnit = nameAmountAndUnit!.unit {
                item.unit = itemUnit
                if item.amount == nil {
                    item.amount = 1
                }
            } else {
                item.unit = UnitHelper.instance.NONE
            }
            
            item.group = autoCompletionHelper.getGroupForItem(item)
            
            return item
        } else {
            return nil
        }

    }
    
    func getItemWithParsedAmountAndUnitForInput(input : String) -> Item? {
        let nameAmountAndUnit = getNameAmountAndUnitForInput(input)
        return getItemForParsedAmountAndUnit(nameAmountAndUnit)
    }
}
