//
//  Item.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 27.07.15.
//  Copyright © 2015 FAU-Inf2. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Item : NSObject, Equatable {

    
    let managedItem : ManagedItem
    private static var managedObjectContext : NSManagedObjectContext?
    
    var amount : Int {
        get {
            return managedItem.amount as Int
        }
        set {
            managedItem.amount = newValue
        }
    }
    
    var bought : Bool {
        get {
            return managedItem.bought as Bool
        }
        set {
            managedItem.bought = newValue
        }
    }
    
    var brand : String? {
        get {
            let managedBrand = managedItem.brand
            if managedBrand.isEmpty {
                return nil
            }
            return managedBrand
        }
        set {
            if newValue == nil {
                managedItem.brand = ""
            } else {
                managedItem.brand = newValue!
            }
        }
    }
    
    var comment : String?{
        get {
            let managedComment = managedItem.comment
            if managedComment.isEmpty {
                return nil
            }
            return managedComment
        }
        set {
            if newValue == nil {
                managedItem.comment = ""
            } else {
                managedItem.comment = newValue!
            }
        }
    }
    
    var highlighted : Bool {
        get {
            return managedItem.highlighted as Bool
        }
        set {
            managedItem.highlighted = newValue
        }
    }
    
    var name : String {
        get {
            return managedItem.name
        }
        set {
            managedItem.name = newValue
        }
    }

    var order : Int? {
        get {
            let managedOrder = managedItem.order as Int
            if managedOrder < 0 {
                return nil
            }
            return managedOrder
        }
        set {
            if newValue == nil {
                managedItem.order = -1
            } else {
                managedItem.order = newValue!
            }
        }
    }
    
    var group : Group? {
        get {
            if let managedItemGroup = managedItem.group as? ManagedGroup{
                if let group = managedItemGroup.group {
                    return group
                }
                return Group(managedGroup: managedItemGroup)
            }
            return nil
        }
        set {
            if newValue == nil {
                managedItem.group = nil
                return
            }
            let managedGroup = newValue!.managedGroup
            managedItem.group = managedGroup
        }
    }
    
    var unit : Unit? {
        get {
            if let managedItemUnit = managedItem.unit as? ManagedUnit{
                if let unit = managedItemUnit.unit {
                    return unit
                }
                return Unit(managedUnit: managedItemUnit)
            }
            return nil
        }
        set {
            if newValue == nil {
                managedItem.unit = nil
                return
            }
            let managedUnit = newValue!.managedUnit
            managedItem.unit = managedUnit
        }
    }
    
    
    
    convenience init(name : String) {
        if Item.managedObjectContext == nil {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            Item.managedObjectContext = appDelegate.managedObjectContext
        }
        
        let managedItem = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: Item.managedObjectContext!) as! ManagedItem
        
        self.init(managedItem: managedItem)
        self.name = name
    }
    
    convenience init (name: String, amount: Int, unit: Unit?, highlighted: Bool, brand: String?, comment: String?, group: Group?) {
        self.init (name: name, amount: amount, highlighted: highlighted, brand: brand, comment: comment, bought: false, order: nil, group: group, unit: unit)
    }
    
    convenience init (name: String, amount: Int, highlighted: Bool, brand: String?, comment: String?, bought: Bool, order: Int?, group: Group?, unit: Unit?) {
        self.init(name: name)
        
        self.amount = amount
        self.highlighted = highlighted
        if let brandText = brand {
            if !brandText.isEmpty {
                self.brand = brandText
            }
        }
        if let commentText = comment {
            if !commentText.isEmpty {
                self.comment = commentText
            }
        }
        self.bought = bought
        self.order = order
        self.group = group
        self.unit = unit
    }
    
    init (managedItem : ManagedItem) {
        self.managedItem = managedItem
        
        super.init()
        
        self.managedItem.item = self
    }
}
    
    func == (left: Item, right: Item) -> Bool {
        if left === right {
            return true
        }
        return left.name == right.name && left.amount == right.amount && left.unit == right.unit && left.highlighted == right.highlighted && left.brand == right.brand && left.comment == right.comment && left.group == right.group
    }
