//
//  ActivityListDataProviderProtocol.swift
//  MyBudget
//
//  Created by Austin Emser on 7/26/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit
import CoreData

public protocol ActivityListDataProviderProtocol: UITableViewDataSource {
    var managedObjectContext: NSManagedObjectContext? { get }
    var account: Account? { get }
    var fetchedResultsController: NSFetchedResultsController? { get }
    weak var tableView: UITableView! { get set }
    
    func fetch()
}
