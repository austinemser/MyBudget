//
//  ActivityListDataSourceProtocol.swift
//  MyBudget
//
//  Created by Austin Emser on 7/19/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit
import CoreData

public protocol ActivityListDataSourceProtocol: UITableViewDataSource {
    var managedObjectContext: NSManagedObjectContext? { get }
    var account: Account? { get }
    weak var tableView: UITableView! { get set }
    
    func addActivity(activity: Activity)
    func fetch()
}
