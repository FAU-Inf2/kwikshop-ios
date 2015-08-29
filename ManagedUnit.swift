//
//  Unit.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 15.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation
import CoreData

class ManagedUnit: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var shortName: String
    @NSManaged var singularName: String
    @NSManaged var allowedPickerIndexType: NSNumber
    
    weak var unit : Unit?
}
