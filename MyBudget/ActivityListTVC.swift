//
//  ActivityTVC.swift
//  MyBudget
//
//  Created by Austin Emser on 7/19/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit
import CoreData

public class ActivityListTVC: UITableViewController, UIAlertViewDelegate, ActivityDetailsVCDelegate {

    public var dataProvider: ActivityListDataProviderProtocol?
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ActivityListTVC.addActivity))
        self.navigationItem.rightBarButtonItem = addButton
        
        assert(dataProvider != nil, "datasrouce should not be nil here")
        tableView.dataSource = dataProvider
        dataProvider?.tableView = tableView
        
        
        setBalanceTitle()
    }
    
    func updateBalance() {
        
        self.dataProvider?.budget?.updateBalance()
        setBalanceTitle()
    }
    
    func setBalanceTitle() {
        let balance = dataProvider?.budget?.balance?.currencyValue
        self.navigationItem.title = balance
    }
    
    func updateBalance(newBalance: Double) {
        if let budget = dataProvider?.budget {
            budget.balance = newBalance
            ad.saveContext()
            setBalanceTitle()
        }
    }

    func addActivity() {
        performSegueWithIdentifier("activityDetailsVC", sender: nil)
    }
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let activity = dataProvider?.fetchedResultsController!.objectAtIndexPath(indexPath) as! Activity
        performSegueWithIdentifier("activityDetailsVC", sender: activity)
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "activityDetailsVC" {
            let destinationVC = segue.destinationViewController as? ActivityDetailsVC
            destinationVC?.activityToEdit = sender as? Activity
            destinationVC?.delegate = self
            let backItem = UIBarButtonItem()
            backItem.title = "Activity"
            navigationItem.backBarButtonItem = backItem
        }
    }
}
