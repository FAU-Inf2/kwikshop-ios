//
//  AutoCompletionHelper.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 18.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AutoCompletionHelper {
    
    static let instance = AutoCompletionHelper()
    private var itemNames = [String]()
    private var brandNames = [String]()
    private var unitsAndGroups = [String : (Unit?, Group?)]()
    
    private let dbHelper = DatabaseHelper.instance
    private let managedObjectContext : NSManagedObjectContext
    
    private var autoCompletionData = [String : AutoCompletionData]()
    private var autoCompletionBrandData = [String : AutoCompletionBrandData]()
    
    var allAutoCompletionItemNames : [String] {
        return itemNames
    }
    var allAutoCompletionBrandNames : [String] {
        return brandNames
    }
    
    private init() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext!
        
        if let autoCompletion = dbHelper.loadAutoCompletionData() {
            for data in autoCompletion {
                let name = data.name
                autoCompletionData.updateValue(data, forKey: name)
                itemNames.append(name)
                let unit : Unit?
                if let managedUnit = data.unit {
                    if managedUnit.unit != nil {
                        unit = managedUnit.unit
                    } else {
                        unit = Unit(managedUnit: managedUnit)
                    }
                } else {
                    unit = nil
                }
                let group : Group?
                if let managedGroup = data.group {
                    if managedGroup.group != nil {
                        group = managedGroup.group
                    } else {
                        group = Group(managedGroup: managedGroup)
                    }
                } else {
                    group = nil
                }
                
                if unit != nil || group != nil {
                    unitsAndGroups.updateValue((unit, group), forKey: name)
                }
                
            }
        }
        
        if let brandCompletion = dbHelper.loadAutoCompletionBrandData() {
            for data in brandCompletion {
                let brand = data.brand
                autoCompletionBrandData.updateValue(data, forKey: brand)
                brandNames.append(brand)
            }
        }
    }
    
    func createOrUpdateAutoCompletionDataForName(name: String) {
        createOrUpdateAutoCompletionDataForName(name, unit: nil, group: nil)
    }
    
    func createOrUpdateAutoCompletionDataForName(name: String, unit: Unit?) {
        createOrUpdateAutoCompletionDataForName(name, unit: unit, group: nil)
    }
    
    func createOrUpdateAutoCompletionDataForName(name: String, group: Group?) {
        createOrUpdateAutoCompletionDataForName(name, unit: nil, group: group)
    }
    
    func createOrUpdateAutoCompletionDataForItem(item: Item) {
        createOrUpdateAutoCompletionDataForName(item.name, unit: item.unit, group: item.group)
        if let brand = item.brand {
            createOrUpdateAutoCompletionBrandDataForBrand(brand)
        }
    }
    
    func createOrUpdateAutoCompletionDataForName(name: String, unit: Unit?, group: Group?) {
        var newValue = false
        if !contains(itemNames, name) {
            itemNames.append(name)
            newValue = true
        }
        if unit != nil || group != nil {
            unitsAndGroups.updateValue((unit, group), forKey: name)
        } else if !newValue {
            // unit and group are nil
            unitsAndGroups.removeValueForKey(name)
        }
        let data : AutoCompletionData
        if newValue {
            data = NSEntityDescription.insertNewObjectForEntityForName("AutoCompletionData", inManagedObjectContext: managedObjectContext) as! AutoCompletionData
        } else {
            data = autoCompletionData[name]!
        }
        autoCompletionData.updateValue(data, forKey: name)
            
        data.name = name
        data.unit = unit?.managedUnit
        data.group = group?.managedGroup
        
        dbHelper.saveData()
    }
    
    func createOrUpdateAutoCompletionBrandDataForBrand(brand: String) {
        let data : AutoCompletionBrandData
        if !contains(brandNames, brand) {
            brandNames.append(brand)
            data = NSEntityDescription.insertNewObjectForEntityForName("AutoCompletionBrandData", inManagedObjectContext: managedObjectContext) as! AutoCompletionBrandData
        } else {
            data = autoCompletionBrandData[brand]!
        }
        autoCompletionBrandData.updateValue(data, forKey: brand)
        
        data.brand = brand
        dbHelper.saveData()
    }
    
    func getGroupForItem(item: Item) -> Group {
        return getGroupForName(item.name)
    }
    
    func getGroupForName(name: String) -> Group {
        if let unitAndGroup = unitsAndGroups[name] {
            if let group = unitAndGroup.1 {
                return group
            }
        }
        return GroupHelper.instance.OTHER
    }
    
    func getUnitForItem(item: Item) -> Unit? {
        return getUnitForName(item.name)
    }
    
    func getUnitForName(name: String) -> Unit? {
        if let unitAndGroup = unitsAndGroups[name] {
            return unitAndGroup.0
        } else {
            return nil
        }
    }
    
    func possibleCompletionsForQuickAddTextWithNameAmountAndUnit(nameAmountAndUnit : (String, Int?, Unit?)) -> [String] {
        return possibleCompletionsForQuickAddTextWithName(nameAmountAndUnit.0, amount: nameAmountAndUnit.1, andUnit: nameAmountAndUnit.2)
    }
    
    func possibleCompletionsForQuickAddTextWithName(name: String, amount: Int?, andUnit unit: Unit?) -> [String] {
        var completions = possibleCompletionsForItemName(name)
        if amount != nil {
            let prefix : String
            if unit != nil {
                prefix = "\(amount!) \(unit!.name) "
            } else {
                prefix = "\(amount!) "
            
                // also units should be suggested
                let unitDelegate = UnitDelegate(pickerView: nil)
                var unitNames = [String]()
                
                for unit in unitDelegate.data {
                    unitNames.append("\(unit.name) ")
                }
                
                let unitSuggestions = filteredCompletionsForSuggestions(unitNames, andString: name)
                completions += unitSuggestions
            }

            
            let numberOfCompletions = completions.count
            
            for index in 0 ..< numberOfCompletions {
                completions[index] = prefix + completions[index]
            }
            
        }
        return completions
    }
    
    func possibleCompletionsForItemName(string: String) -> [String] {
        return filteredCompletionsForSuggestions(itemNames, andString: string)
    }
    
    func possibleCompletionsForBrand(string: String) -> [String] {
        return filteredCompletionsForSuggestions(brandNames, andString: string)
    }
    
    private func filteredCompletionsForSuggestions(suggestions: [String], andString string: String) -> [String] {
        let completions = suggestions.filter(
            { suggestion -> Bool in
                return suggestion.lowercaseString.hasPrefix(string.lowercaseString)
        })
        return completions
    }
}