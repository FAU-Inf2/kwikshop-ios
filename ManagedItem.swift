//
//  Item.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 15.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation
import CoreData

class ManagedItem: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var amout: NSNumber
    @NSManaged var highlighted: NSNumber
    @NSManaged var brand: String
    @NSManaged var comment: String
    @NSManaged var bought: NSNumber
    @NSManaged var order: NSNumber
    @NSManaged var group: NSManagedObject
    @NSManaged var unit: NSManagedObject

}
