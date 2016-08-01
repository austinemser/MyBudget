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
    
    func cache() {
        self.archived = NSDate()
        ad.saveContext()
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
        
        ad.saveContext()
        budget.notifyNewBudget()
        return budget
    }
    
    func notifyNewBudget() {
        let userInfo = ["Budget":self]
        NSNotificationCenter.defaultCenter().postNotificationName("BudgetAvailable", object: nil, userInfo: userInfo)
    }
}
