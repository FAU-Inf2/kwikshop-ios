//
//  PickerIndex.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 24.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PickerIndex {
    
    private var managedPickerIndex : ManagedPickerIndex
    
    var index : Int {
        get {
            return managedPickerIndex.index as Int
        }
        set {
            managedPickerIndex.index = newValue
        }
    }
    
    init (managedPickerIndex: ManagedPickerIndex) {
        self.managedPickerIndex = managedPickerIndex
    }    
}