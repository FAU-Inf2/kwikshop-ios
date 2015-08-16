//
//  Group.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 31.07.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Group : Equatable {

    static let OTHER =                  Group(name: "group_other")
    static let BABY_FOODS =             Group(name: "group_babyFoods")
    static let BEVERAGES =              Group(name: "group_beverages")
    static let BREAK_PASTRIES =         Group(name: "group_breakPastries")
    static let DAIRY =                  Group(name: "group_dairy")
    static let FROZEN_AND_CONVENIENCE = Group(name: "group_frozenAndConvenience")
    static let FRUITS_AND_VEGETABLES =  Group(name: "group_fruitsAndVegetables")
    static let HEALTH_AND_HYGIENE =     Group(name: "group_healthAndHygiene")
    static let HOUSEHOLD =              Group(name: "group_household")
    static let INGREDIENTS_AND_SPICES = Group(name: "group_ingredientsAndSpices")
    static let MEAT_AND_FISH =          Group(name: "group_meatAndFish")
    static let PASTA =                  Group(name: "group_pasta")
    static let PET_SUPPLIES =           Group(name: "group_petSupplies")
    static let SWEETS_AND_SNACKS =      Group(name: "group_sweetsAndSnacks")
    static let TOBACCO =                Group(name: "group_tobacco")
    static let COFFEE_AND_TEA =         Group(name: "group_coffeeAndTea")

    private static var managedObjectContext : NSManagedObjectContext?
    
    var name : String {
        get {
            return managedGroup.name
        }
    }
    
    private let managedGroup : ManagedGroup
    
    init(name : String){
        if Group.managedObjectContext == nil {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            Group.managedObjectContext = appDelegate.managedObjectContext
        }
        
        managedGroup = NSEntityDescription.insertNewObjectForEntityForName("Group", inManagedObjectContext: Group.managedObjectContext!) as! ManagedGroup
        
        managedGroup.name = name
    }
    
    init (managedGroup: ManagedGroup) {
        self.managedGroup = managedGroup
    }
    
}

func == (left : Group, right : Group) -> Bool {
    return left.name == right.name
}