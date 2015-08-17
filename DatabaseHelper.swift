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
    
    private static var managedObjectContext : NSManagedObjectContext?
    
    /*static func getManagedObjectContext(appDelegate : AppDelegate?) -> NSManagedObjectContext?{
        if let context = managedObjectContext {
            return context
        }
        if let delegate = appDelegate {
            managedObjectContext = delegate.managedObjectContext
            return managedObjectContext
        }
        
        if let myAppDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            let managedObjectContext = myAppDelegate.managedObjectContext
            self.managedObjectContext = managedObjectContext
        }
        return self.managedObjectContext
    }*/
    
    private static func getManagedObjectContext() -> NSManagedObjectContext?{
        if let context = managedObjectContext {
            return context
        }
        if let myAppDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            let managedObjectContext = myAppDelegate.managedObjectContext
            self.managedObjectContext = managedObjectContext
        }
        return self.managedObjectContext
    }

    /*static func initWithAppDelegate(appDelegate : AppDelegate) {
        if managedObjectContext == nil {
            managedObjectContext = appDelegate.managedObjectContext
        }
    }*/
    
    static func loadShoppingLists() -> [ShoppingList]? {
        let fetchRequest = NSFetchRequest(entityName: "ShoppingList")
        let managedObjectContext = DatabaseHelper.getManagedObjectContext()
        var result : [ShoppingList]? = nil
        
        // Execute the fetch request, and cast the results to an array of ShoppingList objects
        if let fetchResults = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as? [ManagedShoppingList] {
            let shoppingLists = ShoppingList.getShoppingListsFromManagedShoppingLists(fetchResults)
            result = shoppingLists
        }
        return result
    }
    
    static func saveData() -> Bool {
        if let managedObjectContext = getManagedObjectContext() {
            return managedObjectContext.save(nil)
        }
        return false
    }
}
