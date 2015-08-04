//
//  Group.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 31.07.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation

class Group {

    static let OTHER = Unit(id: 0, name: "group_other")
    static let BABY_FOODS = Unit(id: 1, name: "group_babyFoods")
    static let BEVERAGES = Unit(id: 2, name: "group_beverages")
    static let BREAK_PASTRIES = Unit(id: 3, name: "group_breakPastries")
    static let DAIRY = Unit(id: 4, name: "group_dairy")
    static let FROZEN_AND_CONVENIENCE = Unit(id: 5, name: "group_frozenAndConvenience")
    static let FRUITS_AND_VEGETABLES = Unit(id: 6, name: "group_fruitsAndVegetables")
    static let HEALTH_AND_HYGIENE = Unit(id: 7, name: "group_healthAndHygiene")
    static let HOUSEHOLD = Unit(id: 8, name: "group_household")
    static let INGREDIENTS_AND_SPICES = Unit(id: 9, name: "group_ingredientsAndSpices")
    static let MEAT_AND_FISH = Unit(id: 10, name: "group_meatAndFish")
    static let PASTA = Unit(id: 11, name: "group_pasta")
    static let PET_SUPPLIES = Unit(id: 12, name: "group_petSupplies")
    static let SWEETS_AND_SNACKS = Unit(id: 13, name: "group_sweetsAndSnacks")
    static let TOBACCO = Unit(id: 14, name: "group_tobacco")
    static let COFFEE_AND_TEA = Unit(id: 15, name: "group_coffeeAndTea")

    let id : Int
    let name : String
    
    init(id : Int, name : String){
        self.id = id
        self.name = name
    }
    
}