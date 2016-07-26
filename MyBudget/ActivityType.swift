//
//  ActivityType.swift
//  MyBudget
//
//  Created by Austin Emser on 7/23/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import Foundation
import CoreData


class ActivityType: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    class func initDefaultActivityTypes() {
        let defaultActivityTypes = ["Groceries", "Food", "Bar", "Entertainment", "Technology"]
        for activityTypeStr in defaultActivityTypes {
            let activityType = NSEntityDescription.insertNewObjectForEntityForName("ActivityType", inManagedObjectContext: ad.managedObjectContext) as! ActivityType
            activityType.name = activityTypeStr
        }
        ad.saveContext()
    }
    
    class func create(name: String) {
        let activityType = NSEntityDescription.insertNewObjectForEntityForName("ActivityType", inManagedObjectContext: ad.managedObjectContext) as! ActivityType
        activityType.name = name
        ad.saveContext()
    }
}
