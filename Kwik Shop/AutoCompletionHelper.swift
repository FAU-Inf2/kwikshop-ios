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
    private var unitsAndGroups = [String : (Unit?, Group?)]()
    
    private let dbHelper = DatabaseHelper.instance
    private let managedObjectContext : NSManagedObjectContext
    
    private var autoCompletionData = [String : AutoCompletionData]()
    
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
            // unit and group are nil
            unitsAndGroups.removeValueForKey(name)
        }
        let data : AutoCompletionData
        if let dat = autoCompletionData[name] {
            data = dat
        } else {
            data = NSEntityDescription.insertNewObjectForEntityForName("AutoCompletionData", inManagedObjectContext: managedObjectContext) as! AutoCompletionData
        }
        
        data.name = name
        data.unit = unit?.managedUnit
        data.group = group?.managedGroup
        
        dbHelper.saveData()
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