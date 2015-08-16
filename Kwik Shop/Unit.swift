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

class Unit : NSObject, Equatable{
    
    static let BAG =        Unit(name: "unit_bag")
    static let BOTTLE =     Unit(name: "unit_bottle")
    static let BOX =        Unit(name: "unit_box")
    static let DOZEN =      Unit(name: "unit_dozen")
    static let GRAM =       Unit(name: "unit_gram", shortName: "unit_gram_short")
    static let KILOGRAM =   Unit(name: "unit_kilogram", shortName: "unit_kilogram_short")
    static let LITRE =      Unit(name: "unit_litre", shortName: "unit_litre_short")
    static let MILLILITRE = Unit(name: "unit_millilitre", shortName: "unit_millilitre_short")
    static let PACK =       Unit(name: "unit_pack")
    static let PIECE =      Unit(name: "unit_piece", shortName: "unit_piece_short")
    
    private static var managedObjectContext : NSManagedObjectContext?
    
    let managedUnit : ManagedUnit
    
    var name : String {
        get {
            return managedUnit.name
        }
    }
    
    var shortName : String {
        get {
            if managedUnit.shortName != "" {
                return managedUnit.shortName.localized
            }
            return name.localized
        }
    }
    
    convenience init(name : String, shortName : String){
        self.init(name: name)
        managedUnit.shortName = shortName
    }
    
    convenience init(name : String) {
        if Unit.managedObjectContext == nil {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            Unit.managedObjectContext = appDelegate.managedObjectContext
        }
        
        let managedUnit = NSEntityDescription.insertNewObjectForEntityForName("Unit", inManagedObjectContext: Unit.managedObjectContext!) as! ManagedUnit
        
        self.init(managedUnit: managedUnit)
        
        self.managedUnit.name = name

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
    if left.name != right.name {
        return false
    }
    return left.shortName == right.shortName
}