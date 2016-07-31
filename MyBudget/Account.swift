//
//  Account.swift
//  MyBudget
//
//  Created by Austin Emser on 7/20/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import Foundation
import CoreData


public class Account: NSManagedObject {

    func updateBalance() {
        let fetchRequest = NSFetchRequest(entityName: "Activity")
        fetchRequest.predicate = NSPredicate(format: "account = %@", self)
        do {
            let activities = try self.managedObjectContext?.executeFetchRequest(fetchRequest) as! [Activity]
            let activityTotal = activities.reduce(0.0) { $0 + ($1.amount?.doubleValue ?? 0) }
            if let currentBalance = self.balance {
                self.balance = NSNumber(double: currentBalance.doubleValue - activityTotal)
            } else {
                //self.balance = NSNumber(double: 0.0 - activityTotal)
            }
            ad.saveContext()
        } catch { }
    }
}
