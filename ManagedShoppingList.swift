//
//  ManagedShoppingList.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 16.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation
import CoreData

class ManagedShoppingList: NSManagedObject {

    @NSManaged var lastModifiedDate: NSDate
    @NSManaged var name: String
    @NSManaged var sortType: NSNumber
    @NSManaged var boughtItems: NSSet
    @NSManaged var notBoughtItems: NSSet

    var shoppingList : ShoppingList?
}
