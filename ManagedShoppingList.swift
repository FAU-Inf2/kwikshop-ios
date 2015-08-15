//
//  ShoppingList.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 15.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation
import CoreData

class ManagedShoppingList: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var sortType: NSNumber
    @NSManaged var lastModifiedDate: NSDate
    @NSManaged var items: NSSet

}
