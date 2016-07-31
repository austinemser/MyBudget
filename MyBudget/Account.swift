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

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.created = NSDate()
    }
    
    func updateBalance() {
        let fetchRequest = NSFetchRequest(entityName: "Activity")
        fetchRequest.predicate = NSPredicate(format: "account = %@", self)
        do {
            let activities = try self.managedObjectContext?.executeFetchRequest(fetchRequest) as! [Activity]
            let activityTotal = activities.reduce(0.0) { $0 + ($1.amount?.doubleValue ?? 0) }
            if let currentBalance = self.balance {
                self.balance = NSNumber(double: currentBalance.doubleValue - activityTotal)
                ad.saveContext()
            }
        } catch { }
    }
    
    class func create(balance: NSNumber, name: String, budget: Budget) -> Account? {
        let account = NSEntityDescription.insertNewObjectForEntityForName("Account", inManagedObjectContext: ad.managedObjectContext) as! Account
        account.balance = balance
        account.budget = budget
        account.name = name
        ad.saveContext()
        
        return account
    }
}
