//
//  ShoppingList.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 27.07.15.
//  Copyright © 2015 FAU-Inf2. All rights reserved.
//

import Foundation

class ShoppingList {
    let id : Int
    let name : String
    var sortType : Int
    var items : [Item]
    var lastModifiedDate : NSDate
    
    init (id : Int, name : String, sortType : Int) {
        self.id = id;
        self.name = name;
        self.sortType = sortType
        self.items = [Item]()
        self.lastModifiedDate = NSDate()
    }
}