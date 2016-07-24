//
//  Activity.swift
//  MyBudget
//
//  Created by Austin Emser on 7/20/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import Foundation
import CoreData


public class Activity: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.created = NSDate()
    }
}
