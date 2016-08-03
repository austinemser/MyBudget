//
//  AccountListDataProviderProtocol.swift
//  MyBudget
//
//  Created by Austin Emser on 7/30/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit
import CoreData

public protocol AccountListDataProviderProtocol: UITableViewDataSource {
    var managedObjectContext: NSManagedObjectContext? { get }
    var user: User? { get }
    var fetchedResultsController: NSFetchedResultsController? { get }
    weak var tableView: UITableView! { get set }
    
    func saveAccount(accountCellSaveButton: AccountCellSaveButton)
    func fetch()
}


