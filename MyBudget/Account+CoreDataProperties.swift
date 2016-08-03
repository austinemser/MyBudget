//
//  Account+CoreDataProperties.swift
//  MyBudget
//
//  Created by Austin Emser on 8/3/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Account {

    @NSManaged var balance: NSNumber?
    @NSManaged var created: NSDate?
    @NSManaged var name: String?
    @NSManaged var user: User?

}
