//
//  DatabaseHelper.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 15.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation
import CoreData

class DatabaseHelper: NSObject {
    
    private static var managedObjectContext : NSManagedObjectContext?
    
    static func getManagedObjectContext(appDelegate : AppDelegate?) -> NSManagedObjectContext?{
        if let context = managedObjectContext {
            return context
        }
        if let delegate = appDelegate {
            managedObjectContext = delegate.managedObjectContext
            return managedObjectContext
        }
        return nil
    }
    
    static func getManagedObjectContext() -> NSManagedObjectContext?{
        return managedObjectContext
    }

    static func initWithAppDelegate(appDelegate : AppDelegate) {
        if managedObjectContext == nil {
            managedObjectContext = appDelegate.managedObjectContext
        }
    }
    
}
