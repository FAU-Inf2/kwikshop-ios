//
//  AutoCompletionData.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 18.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation
import CoreData

class AutoCompletionData: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var group: ManagedGroup?
    @NSManaged var unit: ManagedUnit?

}
