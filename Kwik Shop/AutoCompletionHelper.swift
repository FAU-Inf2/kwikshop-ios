//
//  AutoCompletionHelper.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 18.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation

class AutoCompletionHelper {
    
    static let instance = AutoCompletionHelper()
    private var itemNames = [String]()
    private var unitsAndGroups = [String : (Unit?, Group?)]()
    
    private init() {
        // private initalizer to prevent other classes to use the default initalizer
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
            unitsAndGroups.removeValueForKey(name)
        }
    }
    
    func getGroupForItem(item: Item) -> Group? {
        return getGroupForName(item.name)
    }
    
    func getGroupForName(name: String) -> Group? {
        if let unitAndGroup = unitsAndGroups[name] {
            return unitAndGroup.1
        } else {
            return nil
        }
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
    
    func possibleCompletionsForString(string: String) -> [String] {
        return itemNames
    }
}