//
//  Budget+CoreDataProperties.swift
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

extension Budget {

    @NSManaged var balance: NSNumber?
    @NSManaged var created: NSDate?
    @NSManaged var archived: NSDate?
    @NSManaged var accounts: NSSet?
    @NSManaged var activities: NSSet?
    @NSManaged var user: User?

}
