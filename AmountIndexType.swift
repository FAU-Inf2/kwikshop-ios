//
//  AmountIndexType.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 31.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation

enum AmountIndexType: Int {
    case typical = 1, onlySmallValues, alsoBigValues, typicalWithNil
    
    private var TYPICAL_WITH_NIL : [Int?] {
        return [nil] + TYPICAL
    }
    
    private var TYPICAL : [Int?] {
        return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 15, 20, 25, 30, 40, 50, 60, 70, 75, 80, 90, 100, 125, 150, 175, 200, 250, 300, 350, 400, 450, 500, 600, 700, 750, 800, 900, 1000]
    }
    
    
    private var ONLY_SMALL : [Int?] {
        return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 25, 30, 35, 40, 45, 50, 75, 100]
    }
    
    private var ALSO_BIG : [Int?] {
        return TYPICAL + [1250, 1500, 1750, 2000, 2250, 2500, 2750, 3000, 3500, 4000, 4500, 5000, 6000, 7000, 8000, 9000, 10000]
    }
    
    var indices : [Int?] {
        get {
            switch self {
            case .typical:
                return TYPICAL
            case .onlySmallValues:
                return ONLY_SMALL
            case .alsoBigValues:
                return ALSO_BIG
            case .typicalWithNil:
                return TYPICAL_WITH_NIL
            }
        }
    }
}
