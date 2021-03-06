//
//  Unit.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 31.07.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Unit : NSObject{
    
    private static var managedObjectContext : NSManagedObjectContext?
    
    let managedUnit : ManagedUnit
    
    var notLocalizedName : String {
        get {
            return managedUnit.name
        }
    }
    
    var name : String {
        get {
            return managedUnit.name.localized
        }
    }
    
    var shortestPossibleDescription : String {
        get {
            if managedUnit.shortName != "" {
                return managedUnit.shortName.localized
            }
            return managedUnit.name.localized
        }
    }
    
    var shortestPossibleSingularDescription : String {
        get {
            if managedUnit.shortName != "" {
                return managedUnit.shortName.localized
            }
            return managedUnit.singularName.localized
        }
    }

    
    var shortName : String? {
        get {
            return managedUnit.shortName.localized
        }
    }
    
    var singularName : String {
        get {
            return managedUnit.singularName.localized
        }
    }
    
    var allowedPickerAmounts : [Int?] {
        get {
            let typeNumber = managedUnit.allowedPickerIndexType.integerValue
            return AmountIndexType(rawValue: typeNumber)!.indices
        }
    }
    
    var allowedPickerIndexType : AmountIndexType {
        get {
            let typeNumber = managedUnit.allowedPickerIndexType.integerValue
            return AmountIndexType(rawValue: typeNumber)!
        }
        set {
            let type = newValue
            managedUnit.allowedPickerIndexType = type.rawValue
        }
    }
    
    convenience init(name: String, singularName: String, shortName: String?){
        self.init(name: name, singularName: singularName)
        managedUnit.shortName = shortName ?? ""
    }
    
    convenience init(name: String, singularName: String, allowedPickerIndexType: AmountIndexType) {
        self.init(name: name, singularName: singularName, shortName: nil, allowedPickerIndexType: allowedPickerIndexType)
    }
    
    convenience init(name: String, singularName: String, shortName: String?, allowedPickerIndexType: AmountIndexType) {
        self.init(name: name, singularName: singularName, shortName: shortName)
        managedUnit.allowedPickerIndexType = allowedPickerIndexType.rawValue
    }
    
    convenience init(name: String, singularName: String) {
        if Unit.managedObjectContext == nil {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            Unit.managedObjectContext = appDelegate.managedObjectContext
        }
        
        let managedUnit = NSEntityDescription.insertNewObjectForEntityForName("Unit", inManagedObjectContext: Unit.managedObjectContext!) as! ManagedUnit
        
        self.init(managedUnit: managedUnit)
        
        self.managedUnit.name = name
        self.managedUnit.singularName = singularName

    }
    
    init(managedUnit: ManagedUnit) {
        self.managedUnit = managedUnit
        
        super.init()
        
        self.managedUnit.unit = self
    }
}

func == (left: Unit, right: Unit) -> Bool {
    if left === right {
        return true
    }
    
    if left.shortestPossibleDescription != right.shortestPossibleDescription {
        return false
    }
    
    return left.name == right.name
}