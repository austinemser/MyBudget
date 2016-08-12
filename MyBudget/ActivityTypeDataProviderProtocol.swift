//
// Created by Austin Emser on 8/8/16.
// Copyright (c) 2016 AustinEmser. All rights reserved.
//

import UIKit
import CoreData

public protocol ActivityTypeDataProviderProtocol : UITableViewDataSource {
    var managedObjectContext: NSManagedObjectContext? { get }
    var fetchedResultsController: NSFetchedResultsController? { get }
    weak var tableView: UITableView! {get set }

    func fetch()
}
