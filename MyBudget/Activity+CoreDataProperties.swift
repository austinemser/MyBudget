//
//  Activity+CoreDataProperties.swift
//  MyBudget
//
//  Created by Austin Emser on 7/30/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Activity {

    @NSManaged var amount: NSNumber?
    @NSManaged var created: NSDate?
    @NSManaged var name: String?
    @NSManaged var sectionIdentifier: String?
    @NSManaged var type: String?
    @NSManaged var activityType: ActivityType?
    @NSManaged var budget: Budget?

}
