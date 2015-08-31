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
    
    var sortType : SortType {
        get {
            let sortTypeNumber = managedShoppingList.sortType.integerValue
            return SortType(rawValue: sortTypeNumber)!
        }
        set {
            let type = newValue
            managedShoppingList.sortType = type.rawValue
        }
    }
    
    var notBoughtItems : [Item] {
        get {
            let managedItems = managedShoppingList.notBoughtItems.array as! [ManagedItem]
            var items = [Item]()
            for managedItem in managedItems {
                
                assert(!(managedItem.bought as Bool), "A bought item appeared in the not bought list\n\(managedItem)\n")
                
                if let item = managedItem.item {
                    items.append(item)
                } else {
                    items.append(Item(managedItem: managedItem))
                }
            }
            return items
        }
        set {
            let items = NSMutableOrderedSet()
            for item in newValue {
                assert(!item.bought, "Tried to add a bought item to the not bought list\n\(item)\n")
                items.addObject(item.managedItem)
            }
            managedShoppingList.notBoughtItems = items
        }
    }
    var boughtItems : [Item] {
        get {
            let managedItems = managedShoppingList.boughtItems.array as! [ManagedItem]
            var items = [Item]()
            for managedItem in managedItems {
                
                assert(managedItem.bought as Bool, "A not bought item appeared in the bought list\n\(managedItem)\n")
                
                if let item = managedItem.item {
                    items.append(item)
                } else {
                    items.append(Item(managedItem: managedItem))
                }
            }
            return items
        }
        set {
            let items = NSMutableOrderedSet()
            for item in newValue {
                assert(item.bought, "Tried to add a not bought item to the bought list\n\(item)\n")
                items.addObject(item.managedItem)
            }
            managedShoppingList.boughtItems = items
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
    
    static func getShoppingListsFromManagedShoppingLists(managedShoppingLists: [ManagedShoppingList]) -> [ShoppingList] {
        var lists = [ShoppingList]()
        for managed in managedShoppingLists {
            if let list = managed.shoppingList {
                lists.append(list)
            } else {
                lists.append(ShoppingList(managedShoppingList: managed))
            }
        }
        return lists
    }
    
    func swapItemsAtIndices(#initialIndex: Int?, newIndex: Int?){
        var index : Int! = nil
        if let firstIndex = initialIndex {
            // moving an item
            if let secondIndex = newIndex {
                // swapping it with another item
                let first = items[firstIndex]
                let second = items[secondIndex]
                
                if !first.bought && !second.bought {
                    var notBoughtItems = self.notBoughtItems
                    swap(&notBoughtItems[firstIndex], &notBoughtItems[secondIndex])
                    self.notBoughtItems = notBoughtItems
                } else if first.bought && second.bought {
                    let numberOfNotBoughtItems = notBoughtItems.count
                    let firstBoughtIndex = firstIndex - numberOfNotBoughtItems
                    let secondBoughtIndex = secondIndex - numberOfNotBoughtItems
                    
                    var boughtItems = self.boughtItems
                    swap(&boughtItems[firstBoughtIndex], &boughtItems[secondBoughtIndex])
                    self.boughtItems = boughtItems
                } else {
                    assertionFailure("trying to swap two items, that can't be swapped")
                }
                return
            } else {
                // swapping it with the shopping list separator
                index = firstIndex
            }
        } else {
            // moving the separator
            if let secondIndex = newIndex {
                index = secondIndex
            } else {
                assertionFailure("trying to swap two items, while both indices are nil")
            }
        }
        
        let item = items[index]
        if item.bought {
            let boughtIndex = index - notBoughtItems.count
            boughtItems.removeAtIndex(boughtIndex)
            item.bought = false
            notBoughtItems.append(item)
        } else {
            notBoughtItems.removeLast()
            item.bought = true
            boughtItems.insert(item, atIndex: 0)
        }
    }
    
    convenience init (name : String, sortType : SortType) {
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
        self.init(name: name, sortType: SortType.manual)
    }
    
    init (managedShoppingList: ManagedShoppingList) {
        self.managedShoppingList = managedShoppingList
        
        super.init()
        
        self.managedShoppingList.shoppingList = self
    }
}


