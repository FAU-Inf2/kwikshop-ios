//
//  DatabaseHelper.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 15.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DatabaseHelper: NSObject {
    
    private let managedObjectContext : NSManagedObjectContext
    
    static let instance = DatabaseHelper()
    
    private override init() {
        let myAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = myAppDelegate.managedObjectContext
        self.managedObjectContext = managedObjectContext!
        super.init()
        
        //printNumberOfItemsInDB()
        printNumberOfUnitsInDB()
        printNumberOfGroupsInDB()
    }
    
    private func printNumberOfItemsInDB() {
        let fetchRequest = NSFetchRequest(entityName: "Item")
        var result = [Item]()
        
        if let fetchResults = self.managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [ManagedItem] {
            for managed in fetchResults {
                if let item = managed.item {
                    result.append(item)
                } else {
                    let item = Item(managedItem: managed)
                    result.append(item)
                }
            }
        }
        
        println("Number of items in DB: \(result.count)")
    }
    
    private func printNumberOfUnitsInDB() {
        let fetchRequest = NSFetchRequest(entityName: "Unit")
        var result = [Unit]()
        
        if let fetchResults = self.managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [ManagedUnit] {
            for managed in fetchResults {
                if let unit = managed.unit {
                    result.append(unit)
                } else {
                    let unit = Unit(managedUnit: managed)
                    result.append(unit)
                }
            }
        }
        
        println("Number of units in DB: \(result.count)")
    }
    
    private func printNumberOfGroupsInDB() {
        let fetchRequest = NSFetchRequest(entityName: "Group")
        var result = [Group]()
        
        if let fetchResults = self.managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [ManagedGroup] {
            for managed in fetchResults {
                if let group = managed.group {
                    result.append(group)
                } else {
                    let group = Group(managedGroup: managed)
                    result.append(group)
                }
            }
        }
        
        println("Number of groups in DB: \(result.count)")
    }
    
    func loadShoppingLists() -> [ShoppingList]? {
        let fetchRequest = NSFetchRequest(entityName: "ShoppingList")
        var result : [ShoppingList]? = nil
        
        // Execute the fetch request, and cast the results to an array of ShoppingList objects
        if let fetchResults = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [ManagedShoppingList] {
            let shoppingLists = ShoppingList.getShoppingListsFromManagedShoppingLists(fetchResults)
            result = shoppingLists
        }
        return result
    }
    
    func loadGroups() -> [Group]? {
        let fetchRequest = NSFetchRequest(entityName: "Group")
        var result : [Group]? = nil
        
        // Execute the fetch request, and cast the results to an array of Group objects
        if let fetchResults = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [ManagedGroup] {
            result = [Group]()
            for managedGroup in fetchResults {
                if let group = managedGroup.group {
                    result!.append(group)
                } else {
                    result!.append(Group(managedGroup: managedGroup))
                }
            }
        }
        return result
    }
    
    func saveData() -> Bool {
        return managedObjectContext.save(nil)
    }
    
    func deleteItem(item : Item) {
        let managedItem = item.managedItem
        delete(managedItem)
        saveData()
    }
    
    func deleteShoppingList(shoppingList: ShoppingList) {
        let managedShoppingList = shoppingList.managedShoppingList
        delete(managedShoppingList)
        saveData()
    }
    
    private func delete(managedObject: NSManagedObject) {
        managedObjectContext.deleteObject(managedObject)
    }
}
