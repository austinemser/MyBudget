//
//  Activity.swift
//  MyBudget
//
//  Created by Austin Emser on 7/20/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import Foundation
import CoreData

public struct ActivityInfo {
    let amount: NSNumber?
    let name: String?
    let activityType: ActivityType?
    let budget: Budget?
}

public class Activity: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        let date = NSDate()
        self.created = date
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        self.sectionIdentifier = formatter.stringFromDate(date)
    }
    
    class func create(activityInfo: ActivityInfo) -> Activity {
        let activity = NSEntityDescription.insertNewObjectForEntityForName("Activity", inManagedObjectContext: ad.managedObjectContext) as! Activity
        activity.name = activityInfo.name
        activity.amount = activityInfo.amount
        activity.activityType = activityInfo.activityType
        activity.budget = activityInfo.budget
        
        ad.saveContext()
        
        return activity
    }
}
