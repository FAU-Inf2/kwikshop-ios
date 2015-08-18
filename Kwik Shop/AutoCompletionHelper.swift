//
//  AutoCompletionHelper.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 18.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation

class AutoCompletionHelper {
    
    
    func createAutoCompletionDataForName(name: String) {
        createAutoCompletionDataForName(name, unit: nil, group: nil)
    }
    
    func createAutoCompletionDataForName(name: String, unit: Unit?) {
        createAutoCompletionDataForName(name, unit: unit, group: nil)
    }
    
    func createAutoCompletionDataForName(name: String, group: Group?) {
        createAutoCompletionDataForName(name, unit: nil, group: group)
    }
    
    func createAutoCompletionDataForName(name: String, unit: Unit?, group: Group?) {
        
    }
}