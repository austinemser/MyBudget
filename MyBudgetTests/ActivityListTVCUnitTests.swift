//
//  ActivityListTVCUnitTests.swift
//  MyBudget
//
//  Created by Austin Emser on 7/26/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit
import XCTest
import CoreData
import MyBudget

class ActivityListTVCUnitTests: XCTestCase {
    
    var viewController: ActivityListTVC!

    class MockDataProvider: NSObject, ActivityListDataProviderProtocol {
        var budget: Budget?
        var managedObjectContext: NSManagedObjectContext?
        var fetchedResultsController: NSFetchedResultsController?
        weak var tableView: UITableView!
        func fetch() { }
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    }
    
    override func setUp() {
        super.setUp()
        
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ActivityListTVC") as! ActivityListTVC
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    

    
    func testDataSourceHasTableViewPropertySetAfterLoading() {
        let mockDataProvider = MockDataProvider()
        
        viewController.dataProvider = mockDataProvider
        
        XCTAssertNil(mockDataProvider.tableView, "Table view should be nil before loading")
        
        let _ = viewController.view

        XCTAssertTrue(mockDataProvider.tableView != nil, "The table view should be set")
        XCTAssert(mockDataProvider.tableView === viewController.tableView, "The Table view should be set to the table view of the data source")
    }

    
}
