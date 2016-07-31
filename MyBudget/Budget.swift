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

    enum BudgetError : ErrorType {
        case UnarchivedBudget
        case NoUser
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.created = NSDate()
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
    
    class func create(balance: Double) throws -> Budget {
        guard let user = ad.getDefaultUser() else {
            throw BudgetError.NoUser
        }
        
        guard user.activeBudget == nil else {
            throw BudgetError.UnarchivedBudget
        }
        
        
        let budget = NSEntityDescription.insertNewObjectForEntityForName("Budget", inManagedObjectContext: ad.managedObjectContext) as! Budget
        budget.user = user
        budget.balance = balance
        
        //Create default account
        Account.create(0, name: "Safe To Spend", budget: budget)
        
        ad.saveContext()
        
        return budget
    }
}
