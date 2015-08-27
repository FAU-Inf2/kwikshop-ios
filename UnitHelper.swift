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
    let NONE : Unit
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
                var NONE : Unit? = nil
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
                    switch unit.notLocalizedName {
                    case "unit_none":
                        NONE = unit
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
                self.NONE = NONE!
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
        NONE =       Unit(name: "unit_none", singularName: "unit_none", allowedPickerIndexType: AmountIndexType.typical)
        BAG =        Unit(name: "unit_bag", singularName: "unit_bag_singular", allowedPickerIndexType: AmountIndexType.typical)
        BOTTLE =     Unit(name: "unit_bottle", singularName: "unit_bottle_singular", allowedPickerIndexType: AmountIndexType.typical)
        BOX =        Unit(name: "unit_box", singularName: "unit_box_singular", allowedPickerIndexType: AmountIndexType.typical)
        DOZEN =      Unit(name: "unit_dozen", singularName: "unit_dozen_singular", allowedPickerIndexType: AmountIndexType.typical)
        GRAM =       Unit(name: "unit_gram", singularName: "unit_gram_singular", shortName: "unit_gram_short", allowedPickerIndexType: AmountIndexType.alsoBigValues)
        KILOGRAM =   Unit(name: "unit_kilogram", singularName: "unit_kilogram_singular", shortName: "unit_kilogram_short", allowedPickerIndexType: AmountIndexType.onlySmallValues)
        LITRE =      Unit(name: "unit_litre", singularName: "unit_litre_singular", shortName: "unit_litre_short", allowedPickerIndexType: AmountIndexType.onlySmallValues)
        MILLILITRE = Unit(name: "unit_millilitre", singularName: "unit_millilitre_singular", shortName: "unit_millilitre_short", allowedPickerIndexType: AmountIndexType.alsoBigValues)
        PACK =       Unit(name: "unit_pack", singularName: "unit_pack_singular", allowedPickerIndexType: AmountIndexType.typical)
        PIECE =      Unit(name: "unit_piece", singularName: "unit_piece_singular", shortName: "unit_piece_short", allowedPickerIndexType: AmountIndexType.typical)
    }
}

enum AmountIndexType: Int {
    case typical = 1, onlySmallValues, alsoBigValues
    
    private var TYPICAL : [Int] {
        return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 15, 20, 25, 30, 40, 50, 60, 70, 75, 80, 90, 100, 125, 150, 175, 200, 250, 300, 350, 400, 450, 500, 600, 700, 750, 800, 900, 1000]
    }
    
    private var ONLY_SMALL : [Int] {
        return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 25, 30, 35, 40, 45, 50, 75, 100]
    }
    
    private var ALSO_BIG : [Int] {
        return TYPICAL + [1250, 1500, 1750, 2000, 2250, 2500, 2750, 3000, 3500, 4000, 4500, 5000, 6000, 7000, 8000, 9000, 10000]
    }
    
    var indices : [Int] {
        get {
            switch self {
            case .typical:
                return TYPICAL
            case .onlySmallValues:
                return ONLY_SMALL
            case .alsoBigValues:
                return ALSO_BIG
            }
        }
    }
}
