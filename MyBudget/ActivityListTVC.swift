//
//  ActivityTVC.swift
//  MyBudget
//
//  Created by Austin Emser on 7/19/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit
import CoreData

public class ActivityListTVC: UITableViewController, UIAlertViewDelegate {

    public var dataProvider: ActivityListDataProviderProtocol?
    var fetchedResultsController: NSFetchedResultsController? = nil
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ActivityListTVC.addActivity))
        self.navigationItem.rightBarButtonItem = addButton
        
        let balanceButton = UIBarButtonItem(barButtonSystemItem: .Organize, target: self, action: #selector(ActivityListTVC.changeBalance))
        self.navigationItem.leftBarButtonItem = balanceButton
        
        assert(dataProvider != nil, "datasrouce should not be nil here")
        tableView.dataSource = dataProvider
        dataProvider?.tableView = tableView
        
        
        setBalanceTitle()
    }
    
    func setBalanceTitle() {
        let balance = dataProvider?.account?.balance?.stringValue
        self.title = balance
    }
    
    func changeBalance() {
        let alertController = UIAlertController(title: "Balance", message: "Set balance", preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (_) in
            let balanceField = alertController.textFields![0] as UITextField
            if let balanceText = balanceField.text {
                let balanceStr = NSString(string: balanceText)
                let balanceDbl = balanceStr.doubleValue
                self.updateBalance(balanceDbl)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Destructive) { (_) in
            
        }
        alertController.addTextFieldWithConfigurationHandler { (balanceField) in
            balanceField.placeholder = "balance"
            balanceField.keyboardType = .DecimalPad
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func updateBalance(newBalance: Double) {
        if let account = ad.getDefaultAccount() {
            account.balance = newBalance
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
        }
    }
}
