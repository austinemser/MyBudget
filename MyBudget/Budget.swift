//
//  Budget.swift
//  MyBudget
//
//  Created by Austin Emser on 7/30/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import Foundation
import CoreData


public class Budget: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.created = NSDate()
    }
    
    enum BudgetError : ErrorType {
        case UnarchivedBudget
    }
    
    func updateBalance() {
        let fetchRequest = NSFetchRequest(entityName: "Activity")
        fetchRequest.predicate = NSPredicate(format: "budget = %@", self)
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
    
    func createBudget(balance: Double) throws -> Budget {
        guard self.user?.activeBudget == nil else {
            throw BudgetError.UnarchivedBudget
        }
        
        //TODO:
    }
}
