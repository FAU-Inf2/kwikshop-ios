//
//  Group.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 31.07.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation

class Group {

    static let OTHER = Group(id: 0, name: "group_other")
    static let BABY_FOODS = Group(id: 1, name: "group_babyFoods")
    static let BEVERAGES = Group(id: 2, name: "group_beverages")
    static let BREAK_PASTRIES = Group(id: 3, name: "group_breakPastries")
    static let DAIRY = Group(id: 4, name: "group_dairy")
    static let FROZEN_AND_CONVENIENCE = Group(id: 5, name: "group_frozenAndConvenience")
    static let FRUITS_AND_VEGETABLES = Group(id: 6, name: "group_fruitsAndVegetables")
    static let HEALTH_AND_HYGIENE = Group(id: 7, name: "group_healthAndHygiene")
    static let HOUSEHOLD = Group(id: 8, name: "group_household")
    static let INGREDIENTS_AND_SPICES = Group(id: 9, name: "group_ingredientsAndSpices")
    static let MEAT_AND_FISH = Group(id: 10, name: "group_meatAndFish")
    static let PASTA = Group(id: 11, name: "group_pasta")
    static let PET_SUPPLIES = Group(id: 12, name: "group_petSupplies")
    static let SWEETS_AND_SNACKS = Group(id: 13, name: "group_sweetsAndSnacks")
    static let TOBACCO = Group(id: 14, name: "group_tobacco")
    static let COFFEE_AND_TEA = Group(id: 15, name: "group_coffeeAndTea")

    let id : Int
    let name : String
    
    init(id : Int, name : String){
        self.id = id
        self.name = name
    }
    
}