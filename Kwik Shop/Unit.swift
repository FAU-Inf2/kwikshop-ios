//
//  Unit.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 31.07.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation

class Unit {
    let id : Int
    let name : String
    let shortName : String?
    
    init(id : Int, name : String, shortName : String?){
        self.id = id
        self.name = name
        self.shortName = shortName
    }
    
    convenience init (id : Int, name : String) {
        self.init(id: id, name: name, shortName: nil)
    }
    
}