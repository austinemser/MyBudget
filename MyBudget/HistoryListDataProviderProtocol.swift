//
//  HistoryListDataProviderProtocol.swift
//  MyBudget
//
//  Created by Austin Emser on 7/31/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit
import CoreData

public protocol HistoryListDataProviderProtocol: UITableViewDataSource {
    var managedObjectContext: NSManagedObjectContext? { get }
    var user: User? { get }
    var fetchedResultsController: NSFetchedResultsController? { get }
    weak var tableView: UITableView! { get set }

    func fetch()
}
