//
//  PickerIndexHelper.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 24.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PickerIndexHelper {
    static let instance = PickerIndexHelper()
    private var storedPickerIndices : [Int : ManagedPickerIndex]
    private var managedObjectContext : NSManagedObjectContext
    
    private init() {
        let dbHelper = DatabaseHelper.instance
        storedPickerIndices = [Int : ManagedPickerIndex]()
        if let indices = dbHelper.loadManagedPickerIndices() {
            for index in indices {
                storedPickerIndices.updateValue(index, forKey: index.index as Int)
            }
        }
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext!
    }
    
    subscript (index: Int) -> ManagedPickerIndex {
        get {
            if let storedIndex = storedPickerIndices[index] {
                return storedIndex
            } else {
                let pickerIndex = NSEntityDescription.insertNewObjectForEntityForName("PickerIndex", inManagedObjectContext: managedObjectContext) as! ManagedPickerIndex
                storedPickerIndices.updateValue(pickerIndex, forKey: index)
                return pickerIndex
            }
        }
    }
}