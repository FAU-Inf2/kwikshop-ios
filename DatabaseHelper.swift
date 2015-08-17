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
    
    func saveData() -> Bool {
        return managedObjectContext.save(nil)
    }
    
    func deleteItem(item : Item) {
        let managedItem = item.managedItem
        delete(managedItem)
    }
    
    func deleteShoppingList(shoppingList: ShoppingList) {
        let managedShoppingList = shoppingList.managedShoppingList
        delete(managedShoppingList)
    }
    
    private func delete(managedObject: NSManagedObject) {
        managedObjectContext.deleteObject(managedObject)
    }
}
