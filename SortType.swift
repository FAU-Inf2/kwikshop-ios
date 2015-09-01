//
//  SortType.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 31.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation

enum SortType: Int {
    case manual = 0, group, alphabetically, manualWithGroups
    
    var showGroups : Bool {
        switch self {
        case .manual:
            fallthrough
        case .alphabetically:
            return false
        case .group:
            fallthrough
        case .manualWithGroups:
            return true
        }
    }
}
