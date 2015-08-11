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
    var isHighlited = false
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
    
    convenience init (name: String, amount: Int, unit: Unit?, highlight: Bool, brand: String?, comment: String?, group: Group?) {
        self.init(name: name)
        
        self.amount = amount
        self.unit = unit
        self.isHighlited = highlight
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
        self.group = group
    }
}
    
    func == (left: Item, right: Item) -> Bool {
        if left === right {
            return true
        }
        if left.id != nil && left.id == right.id {
            return true
        }
        return left.name == right.name && left.amount == right.amount /*&& left.unit == right.unit*/ && left.isHighlited == right.isHighlited && left.brand == right.brand && left.comment == right.comment /*&& left.group == right.group*/
    }
