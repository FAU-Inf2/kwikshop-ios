//
//  ShoppingList.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 27.07.15.
//  Copyright © 2015 FAU-Inf2. All rights reserved.
//

import Foundation

class ShoppingList {
    var/*let*/ id : Int?
    var name : String
    var sortType : Int?
    
    var notBoughtItems : [Item]
    var boughtItems : [Item]
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
    
    var lastModifiedDate : NSDate
    
    init (id : Int?, name : String, sortType : Int?) {
        self.id = id;
        self.name = name;
        self.sortType = sortType
        self.notBoughtItems = [Item]()
        self.boughtItems = [Item]()
        self.lastModifiedDate = NSDate()
    }
    
    convenience init (name: String) {
        self.init(id: nil, name: name, sortType: nil)
    }
    
    convenience init (managedShoppingList sl: ManagedShoppingList) {
        let name = sl.valueForKey("name") as! String
        let sortType = sl.valueForKey("sortType") as? Int
        let lastModifiedDate = sl.valueForKey("lastModifiedDate") as! NSDate
        let items = sl.mutableSetValueForKey("items").allObjects as! [Item]
        
        self.init(id: nil, name: name, sortType: sortType)
        self.lastModifiedDate = lastModifiedDate
        self.items = items
    }
}


