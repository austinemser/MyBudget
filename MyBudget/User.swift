//
//  User.swift
//  MyBudget
//
//  Created by Austin Emser on 7/30/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import Foundation
import CoreData


public class User: NSManagedObject {
    
    var activeBudget: Budget? {
        get {
            let predicate = NSPredicate(format: "archived = nil")
            
            return budgets?.filteredSetUsingPredicate(predicate).first as? Budget
            
        }
    }
    
}
