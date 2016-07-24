//
//  ActivityTVC.swift
//  MyBudget
//
//  Created by Austin Emser on 7/19/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit
import CoreData

public class ActivityListTVC: UITableViewController, NSFetchedResultsControllerDelegate, UIAlertViewDelegate {

    public var userDefaults = NSUserDefaults.standardUserDefaults()
    public var dataSource: ActivityListDataSource?
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ActivityListTVC.addActivity))
        self.navigationItem.rightBarButtonItem = addButton
        
        let balanceButton = UIBarButtonItem(barButtonSystemItem: .Organize, target: self, action: #selector(ActivityListTVC.changeBalance))
        self.navigationItem.leftBarButtonItem = balanceButton
        
        assert(dataSource != nil, "datasrouce should not be nil here")
        tableView.dataSource = dataSource
        dataSource?.tableView = tableView
        
        self.title = "\(dataSource?.account?.balance!)"
        
        
    }

    func changeBalance() {
        
    }

    func addActivity() {
        let activity = NSEntityDescription.insertNewObjectForEntityForName("Activity", inManagedObjectContext: ad.managedObjectContext) as! Activity
        activity.account = dataSource?.account
        activity.amount = 100
        activity.name = "Test Name 2"
        ad.saveContext()
    }

    @IBAction func changeSorting(sender: UISegmentedControl) {
        userDefaults.setInteger(sender.selectedSegmentIndex, forKey: "sort")
        dataSource?.fetch()
    }
}
