//
//  Item.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 27.07.15.
//  Copyright © 2015 FAU-Inf2. All rights reserved.
//

import Foundation

class Item {
    let id : Int
    var order : Int
    var bought = false
    var name : String
    var amount = 1
    var isHighlited = false
    var brand : String?
    var comment : String?
    
    init(id : Int, order : Int, name : String) {
        self.id = id
        self.order = order
        self.name = name
    }
}