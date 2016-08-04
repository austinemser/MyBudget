//
//  Account.swift
//  MyBudget
//
//  Created by Austin Emser on 7/20/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import Foundation
import CoreData

enum AccountType: Int32 {
    case Credit, Checking, Savings, t401k
}

public struct AccountInfo {
    let balance: NSNumber?
    let name: String?
    let accountType: AccountType?
    let creditLimit: NSNumber?
    let user: User?
}


public class Account: NSManagedObject {
    

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.created = NSDate()
    }
    
    var accountType: AccountType {
        get {
            let intType = self.type?.intValue
            return AccountType(rawValue: intType!)!
        } set {
            self.type = NSNumber(int: newValue.rawValue)
        }
    }
    
    var accountInfo:AccountInfo? {
        get {
            return AccountInfo(balance: self.balance, name: self.name, accountType: self.accountType, creditLimit: self.creditLimit, user: self.user)
        }
    }
    
    class func create(accountInfo: AccountInfo) -> Account? {
        let account = NSEntityDescription.insertNewObjectForEntityForName("Account", inManagedObjectContext: ad.managedObjectContext) as! Account
        
        account.user = accountInfo.user
        account.balance = accountInfo.balance
        account.name = accountInfo.name
        if let accountType = accountInfo.accountType {
            account.accountType = accountType
        }
        account.creditLimit = accountInfo.creditLimit
        
        ad.saveContext()
        
        return account
    }
}

//
//enum EmployeeStatus: Int32 {
//    case ReadyForHire, Hired, Retired, Resigned, Fired, Deceased
//}
//
//class Employee: NSManagedObject {
//    // other properties...
//    
//    @NSManaged private var statusValue: Int32
//    
//    var status: EmployeeStatus {
//        get {
//            return EmployeeStatus(rawValue: self.statusValue)!
//        }
//        set {
//            self.statusValue = newValue.rawValue
//        }
//    }
//}
//
//// Usage
//employee.status = .Hired
//
//struct Salary {
//    let amount: NSDecimalNumber
//}
//
//class Employee: NSManagedObject {
//    // other properties...
//    
//    @NSManaged private var salaryAmount: NSDecimalNumber
//    
//    var salary: Salary {
//        get {
//            return Salary(amount: self.salaryAmount)
//        }
//        set {
//            self.salaryAmount = newValue.amount
//        }
//    }
//}
//
//// Usage
//employee.salary = Salary(amount:10000.0)


