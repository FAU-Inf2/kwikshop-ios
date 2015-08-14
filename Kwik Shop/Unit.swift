//
//  Unit.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 31.07.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation

class Unit : Equatable{
    
    static let BAG = Unit(id: 0, name: "unit_bag")
    static let BOTTLE = Unit(id: 1, name: "unit_bottle")
    static let BOX = Unit(id: 2, name: "unit_box")
    static let DOZEN = Unit(id: 3, name: "unit_dozen")
    static let GRAM = Unit(id: 4, name: "unit_gram", shortName: "unit_gram_short")
    static let KILOGRAM = Unit(id: 5, name: "unit_kilogram", shortName: "unit_kilogram_short")
    static let LITRE = Unit(id: 6, name: "unit_litre", shortName: "unit_litre_short")
    static let MILLILITRE = Unit(id: 7, name: "unit_millilitre", shortName: "unit_millilitre_short")
    static let PACK = Unit(id: 8, name: "unit_pack")
    static let PIECE = Unit(id: 9, name: "unit_piece", shortName: "unit_piece_short")
    
    let id : Int
    let name : String
    private let short : String?
    
    var shortName : String {
        get {
            if short != nil {
                return short!.localized
            }
            return name.localized
        }
    }
    
    init(id : Int, name : String, shortName short : String?){
        self.id = id
        self.name = name
        self.short = short
    }
    
    convenience init (id : Int, name : String) {
        self.init(id: id, name: name, shortName: nil)
    }
}

func == (left: Unit, right: Unit) -> Bool {
    if left.id == right.id {
        return true
    }
    if left.name != right.name {
        return false
    }
    return left.shortName == right.shortName
}