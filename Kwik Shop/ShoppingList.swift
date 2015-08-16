//
//  ShoppingList.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 27.07.15.
//  Copyright © 2015 FAU-Inf2. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ShoppingList : NSObject {
    
    private static var managedObjectContext : NSManagedObjectContext?
    
    var name : String {
        get {
            return managedShoppingList.name
        }
        set {
            managedShoppingList.name = newValue
        }
    }
    
    var sortType : Int? {
        get {
            let sortType = managedShoppingList.sortType as Int
            if sortType > 0 {
                return sortType
            }
            return nil
        }
        set {
            if newValue == nil {
                managedShoppingList.sortType = -1
            } else {
                managedShoppingList.sortType = newValue!
            }
        }
    }
    
    var notBoughtItems : [Item] {
        get {
            return managedShoppingList.notBoughtItems.allObjects as! [Item]
        }
        set {
            //managedShoppingList.notBoughtItems = NSSet(array: newValue)
        }
    }
    var boughtItems : [Item] {
        get {
            return managedShoppingList.boughtItems.allObjects as! [Item]
        }
        set {
            //managedShoppingList.boughtItems = NSSet(array: newValue)
        }
    }
    
    var items : [Item] {
        get {
            let notBought = notBoughtItems ?? [Item]()
            let bought = boughtItems ?? [Item]()
            return notBought + bought
        }
        set (items) {
            var notBought = [Item]()
            var bought = [Item]()
            for item in items {
                if item.bought {
                    bought.append(item)
                } else {
                    notBought.append(item)
                }
            }
            self.notBoughtItems = notBought
            self.boughtItems = bought
        }
    }
    
    var lastModifiedDate : NSDate {
        get {
            return managedShoppingList.lastModifiedDate
        }
        set {
            managedShoppingList.lastModifiedDate = newValue
        }
    }

    
    let managedShoppingList : ManagedShoppingList
    
    convenience init (name : String, sortType : Int?) {
        if ShoppingList.managedObjectContext == nil {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            ShoppingList.managedObjectContext = appDelegate.managedObjectContext
        }
        
        let managedShoppingList = NSEntityDescription.insertNewObjectForEntityForName("ShoppingList", inManagedObjectContext: ShoppingList.managedObjectContext!) as! ManagedShoppingList
        
        self.init(managedShoppingList: managedShoppingList)

        self.name = name;
        self.sortType = sortType
        self.notBoughtItems = [Item]()
        self.boughtItems = [Item]()
        self.lastModifiedDate = NSDate()
    }
    
    convenience init (name: String) {
        self.init(name: name, sortType: nil)
    }
    
    init (managedShoppingList: ManagedShoppingList) {
        self.managedShoppingList = managedShoppingList
        
        super.init()
        
        self.managedShoppingList.shoppingList = self
    }
}


