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

    
    class func create(balance: NSNumber, name: String, user: User) -> Account? {
        let account = NSEntityDescription.insertNewObjectForEntityForName("Account", inManagedObjectContext: ad.managedObjectContext) as! Account
        account.balance = balance
        account.user = user
        account.name = name
        ad.saveContext()
        
        return account
    }
}
