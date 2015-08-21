//
//  Group.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 31.07.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Group : NSObject, Equatable {

    private static var managedObjectContext : NSManagedObjectContext?
    
    var name : String {
        get {
            return managedGroup.name.localized
        }
    }
    
    var notLocalizedName : String {
        get {
            return managedGroup.name
        }
    }
    
    let managedGroup : ManagedGroup
    
    convenience init(name : String){
        if Group.managedObjectContext == nil {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            Group.managedObjectContext = appDelegate.managedObjectContext
        }
        
        let managedGroup = NSEntityDescription.insertNewObjectForEntityForName("Group", inManagedObjectContext: Group.managedObjectContext!) as! ManagedGroup
        
        self.init(managedGroup: managedGroup)
        
        self.managedGroup.name = name
    }
    
    init (managedGroup: ManagedGroup) {
        self.managedGroup = managedGroup
        
        super.init()
        
        self.managedGroup.group = self
    }
    
}

func == (left : Group, right : Group) -> Bool {
    if left === right {
        return true
    }
    return left.name == right.name
}