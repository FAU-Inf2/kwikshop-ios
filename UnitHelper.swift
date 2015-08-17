//
//  UnitHelper.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 17.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation
import CoreData

class UnitHelper{
    let BAG : Unit
    let BOTTLE : Unit
    let BOX : Unit
    let DOZEN : Unit
    let GRAM : Unit
    let KILOGRAM : Unit
    let LITRE : Unit
    let MILLILITRE : Unit
    let PACK : Unit
    let PIECE : Unit
    
    static let instance = UnitHelper()
    private let dbHelper = DatabaseHelper.instance
    private var otherUnits : [Unit]?
    
    private init() {
        let loadedUnits = dbHelper.loadUnits()
        
        if let units = loadedUnits {
            if !units.isEmpty {
                
                var BAG : Unit? = nil
                var BOTTLE : Unit? = nil
                var BOX : Unit? = nil
                var DOZEN : Unit? = nil
                var GRAM : Unit? = nil
                var KILOGRAM : Unit? = nil
                var LITRE : Unit? = nil
                var MILLILITRE : Unit? = nil
                var PACK : Unit? = nil
                var PIECE : Unit? = nil
                
                var otherUnits : [Unit]?
                
                for unit in units {
                    switch unit.name {
                    case "unit_bag":
                        BAG = unit
                    case "unit_bottle":
                        BOTTLE = unit
                    case "unit_box":
                        BOX = unit
                    case "unit_dozen":
                        DOZEN = unit
                    case "unit_gram":
                        GRAM = unit
                    case "unit_kilogram":
                        KILOGRAM = unit
                    case "unit_litre":
                        LITRE = unit
                    case "unit_millilitre":
                        MILLILITRE = unit
                    case "unit_pack":
                        PACK = unit
                    case "unit_piece":
                        PIECE = unit
                    default:
                        if var other = otherUnits {
                            other.append(unit)
                        } else {
                            otherUnits = [Unit]()
                            otherUnits!.append(unit)
                        }
                    }
                }
                self.BAG = BAG!
                self.BOTTLE = BOTTLE!
                self.BOX = BOX!
                self.DOZEN = DOZEN!
                self.GRAM = GRAM!
                self.KILOGRAM = KILOGRAM!
                self.LITRE = LITRE!
                self.MILLILITRE = MILLILITRE!
                self.PACK = PACK!
                self.PIECE = PIECE!
                
                self.otherUnits = otherUnits
                
                return // to prevent creating the groups again
            }
        }
        
        // init groups
        BAG =        Unit(name: "unit_bag")
        BOTTLE =     Unit(name: "unit_bottle")
        BOX =        Unit(name: "unit_box")
        DOZEN =      Unit(name: "unit_dozen")
        GRAM =       Unit(name: "unit_gram", shortName: "unit_gram_short")
        KILOGRAM =   Unit(name: "unit_kilogram", shortName: "unit_kilogram_short")
        LITRE =      Unit(name: "unit_litre", shortName: "unit_litre_short")
        MILLILITRE = Unit(name: "unit_millilitre", shortName: "unit_millilitre_short")
        PACK =       Unit(name: "unit_pack")
        PIECE =      Unit(name: "unit_piece", shortName: "unit_piece_short")

        
        
    }
    
}