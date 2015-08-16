//
//  Group.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 15.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation
import CoreData

class ManagedGroup: NSManagedObject {

    @NSManaged var name: String

    weak var group : Group?
}
