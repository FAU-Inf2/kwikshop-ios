//
//  Unit.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 31.07.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation

class Unit : Equatable{
    
    static let BAG =        Unit(name: "unit_bag")
    static let BOTTLE =     Unit(name: "unit_bottle")
    static let BOX =        Unit(name: "unit_box")
    static let DOZEN =      Unit(name: "unit_dozen")
    static let GRAM =       Unit(name: "unit_gram", shortName: "unit_gram_short")
    static let KILOGRAM =   Unit(name: "unit_kilogram", shortName: "unit_kilogram_short")
    static let LITRE =      Unit(name: "unit_litre", shortName: "unit_litre_short")
    static let MILLILITRE = Unit(name: "unit_millilitre", shortName: "unit_millilitre_short")
    static let PACK =       Unit(name: "unit_pack")
    static let PIECE =      Unit(name: "unit_piece", shortName: "unit_piece_short")
    
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
    
    init(name : String, shortName short : String?){
        self.name = name
        self.short = short
    }
    
    convenience init(name : String) {
        self.init(name: name, shortName: nil)
    }
    
    convenience init(managedUnit: ManagedUnit) {
        let name = managedUnit.valueForKey("name") as! String
        let shortName = managedUnit.valueForKey("shortName") as? String
        self.init(name: name, shortName: shortName)
    }
}

func == (left: Unit, right: Unit) -> Bool {
    if left.name != right.name {
        return false
    }
    return left.shortName == right.shortName
}