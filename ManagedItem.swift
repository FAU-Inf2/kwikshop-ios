//
//  Item.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 16.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation
import CoreData

class ManagedItem: NSManagedObject {

    @NSManaged var amount: NSNumber?
    @NSManaged var bought: NSNumber
    @NSManaged var brand: String
    @NSManaged var comment: String
    @NSManaged var highlighted: NSNumber
    @NSManaged var name: String
    @NSManaged var order: NSNumber
    @NSManaged var group: NSManagedObject
    @NSManaged var unit: NSManagedObject?
    @NSManaged var shoppingListIfBought: NSManagedObject?
    @NSManaged var shoppingListIfNotBought: NSManagedObject?
    
    var item : Item?

}
