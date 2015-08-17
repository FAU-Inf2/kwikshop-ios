//
//  GroupHelper.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 17.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation
import CoreData

class GroupHelper{
    let OTHER : Group
    let BABY_FOODS : Group
    let BEVERAGES : Group
    let BREAK_PASTRIES : Group
    let DAIRY : Group
    let FROZEN_AND_CONVENIENCE : Group
    let FRUITS_AND_VEGETABLES : Group
    let HEALTH_AND_HYGIENE : Group
    let HOUSEHOLD : Group
    let INGREDIENTS_AND_SPICES : Group
    let MEAT_AND_FISH : Group
    let PASTA : Group
    let PET_SUPPLIES : Group
    let SWEETS_AND_SNACKS : Group
    let TOBACCO : Group
    let COFFEE_AND_TEA : Group
    
    static let instance = GroupHelper()
    private let dbHelper = DatabaseHelper.instance
    private var otherGroups : [Group]?
    
    private init() {
        let loadedGroups = dbHelper.loadGroups()
            
        if let groups = loadedGroups {
            if !groups.isEmpty {
                
                var OTHER : Group? = nil
                var BABY_FOODS : Group? = nil
                var BEVERAGES : Group? = nil
                var BREAK_PASTRIES : Group? = nil
                var DAIRY : Group? = nil
                var FROZEN_AND_CONVENIENCE : Group? = nil
                var FRUITS_AND_VEGETABLES : Group? = nil
                var HEALTH_AND_HYGIENE : Group? = nil
                var HOUSEHOLD : Group? = nil
                var INGREDIENTS_AND_SPICES : Group? = nil
                var MEAT_AND_FISH : Group? = nil
                var PASTA : Group? = nil
                var PET_SUPPLIES : Group? = nil
                var SWEETS_AND_SNACKS : Group? = nil
                var TOBACCO : Group? = nil
                var COFFEE_AND_TEA : Group? = nil
                
                var otherGroups : [Group]?
                
                for group in groups {
                    switch group.name {
                    case "group_other":
                        OTHER = group
                    case "group_babyFoods":
                        BABY_FOODS = group
                    case "group_beverages":
                        BEVERAGES = group
                    case "group_breakPastries":
                        BREAK_PASTRIES = group
                    case "group_dairy":
                        DAIRY = group
                    case "group_frozenAndConvenience":
                        FROZEN_AND_CONVENIENCE = group
                    case "group_fruitsAndVegetables":
                        FRUITS_AND_VEGETABLES = group
                    case "group_healthAndHygiene":
                        HEALTH_AND_HYGIENE = group
                    case "group_household":
                        HOUSEHOLD = group
                    case "group_ingredientsAndSpices":
                        INGREDIENTS_AND_SPICES = group
                    case "group_meatAndFish":
                        MEAT_AND_FISH = group
                    case "group_pasta":
                        PASTA = group
                    case "group_petSupplies":
                        PET_SUPPLIES = group
                    case "group_sweetsAndSnacks":
                        SWEETS_AND_SNACKS = group
                    case "group_tobacco":
                        TOBACCO = group
                    case "group_coffeeAndTea":
                        COFFEE_AND_TEA = group
                    default:
                        if var other = otherGroups {
                            other.append(group)
                        } else {
                            otherGroups = [Group]()
                            otherGroups!.append(group)
                        }
                    }
                }
                self.OTHER = OTHER!
                self.BABY_FOODS = BABY_FOODS!
                self.BEVERAGES = BEVERAGES!
                self.BREAK_PASTRIES = BREAK_PASTRIES!
                self.DAIRY = DAIRY!
                self.FROZEN_AND_CONVENIENCE = FROZEN_AND_CONVENIENCE!
                self.FRUITS_AND_VEGETABLES = FRUITS_AND_VEGETABLES!
                self.HEALTH_AND_HYGIENE = HEALTH_AND_HYGIENE!
                self.HOUSEHOLD = HOUSEHOLD!
                self.INGREDIENTS_AND_SPICES = INGREDIENTS_AND_SPICES!
                self.MEAT_AND_FISH = MEAT_AND_FISH!
                self.PASTA = PASTA!
                self.PET_SUPPLIES = PET_SUPPLIES!
                self.SWEETS_AND_SNACKS = SWEETS_AND_SNACKS!
                self.TOBACCO = TOBACCO!
                self.COFFEE_AND_TEA = COFFEE_AND_TEA!
                
                self.otherGroups = otherGroups
                
                return // to prevent creating the groups again
            }
        }
        
        // init groups
        OTHER =                  Group(name: "group_other")
        BABY_FOODS =             Group(name: "group_babyFoods")
        BEVERAGES =              Group(name: "group_beverages")
        BREAK_PASTRIES =         Group(name: "group_breakPastries")
        DAIRY =                  Group(name: "group_dairy")
        FROZEN_AND_CONVENIENCE = Group(name: "group_frozenAndConvenience")
        FRUITS_AND_VEGETABLES =  Group(name: "group_fruitsAndVegetables")
        HEALTH_AND_HYGIENE =     Group(name: "group_healthAndHygiene")
        HOUSEHOLD =              Group(name: "group_household")
        INGREDIENTS_AND_SPICES = Group(name: "group_ingredientsAndSpices")
        MEAT_AND_FISH =          Group(name: "group_meatAndFish")
        PASTA =                  Group(name: "group_pasta")
        PET_SUPPLIES =           Group(name: "group_petSupplies")
        SWEETS_AND_SNACKS =      Group(name: "group_sweetsAndSnacks")
        TOBACCO =                Group(name: "group_tobacco")
        COFFEE_AND_TEA =         Group(name: "group_coffeeAndTea")
        
    
    }

}