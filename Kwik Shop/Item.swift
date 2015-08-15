//
//  Item.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 27.07.15.
//  Copyright © 2015 FAU-Inf2. All rights reserved.
//

import Foundation

class Item  : Equatable {
    var/*let*/ id : Int?
    var order : Int?
    var bought = false
    var name : String
    var amount = 1
    var unit : Unit?
    var highlited = false
    var brand : String?
    var comment : String?
    var group : Group?
    
    init(id : Int?, order : Int?, name : String) {
        self.id = id
        self.order = order
        self.name = name
    }
    
    convenience init (name: String) {
        self.init(id: nil, order: nil, name: name)
    }
    
    convenience init (name: String, amount: Int, unit: Unit?, highlighted: Bool, brand: String?, comment: String?, group: Group?) {
        self.init (name: name, amount: amount, highlighted: highlighted, brand: brand, comment: comment, bought: false, order: nil, group: group, unit: unit)
    }
    
    convenience init (name: String, amount: Int, highlighted: Bool, brand: String?, comment: String?, bought: Bool, order: Int?, group: Group?, unit: Unit?) {
        self.init(id: nil, order: order, name: name)
        
        self.amount = amount
        self.highlited = highlighted
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
    
    
    
    
    convenience init (managedItem item : ManagedItem) {
        let name = item.valueForKey("name") as! String
        let amount = item.valueForKey("amount") as! Int
        let highlighted = item.valueForKey("highlighted") as! Bool
        let brand = item.valueForKey("brand") as? String
        let comment = item.valueForKey("comment") as? String
        let bought = item.valueForKey("bought") as! Bool
        let order = item.valueForKey("order") as? Int
        let group : Group?
        if let managedGroup = item.valueForKey("group") as? ManagedGroup {
            group = Group(managedGroup: managedGroup)
        } else {
            group = nil
        }
        let unit: Unit?
        if let managedUnit = item.valueForKey("unit") as? ManagedUnit {
            unit = Unit(managedUnit: managedUnit)
        } else {
            unit = nil
        }
        
        
        self.init (name: name, amount: amount, highlighted: highlighted, brand: brand, comment: comment, bought: bought, order: order, group: group, unit: unit)
    }
}
    
    func == (left: Item, right: Item) -> Bool {
        if left === right {
            return true
        }
        if left.id != nil && left.id == right.id {
            return true
        }
        return left.name == right.name && left.amount == right.amount /*&& left.unit == right.unit*/ && left.highlited == right.highlited && left.brand == right.brand && left.comment == right.comment /*&& left.group == right.group*/
    }
