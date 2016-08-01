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
    
    public override func awakeFromNib() {
        NSNotificationCenter.defaultCenter().addObserverForName("BudgetAvailable", object: nil, queue: nil) { (note) in
            self.dataProvider = ActivityListDataProvider(budget: note.userInfo!["Budget"] as! Budget)
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ActivityListTVC.addActivity))
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(ActivityListTVC.changeBudget))
        self.navigationItem.rightBarButtonItems = [addButton,editButton]
        
        assert(dataProvider != nil, "datasrouce should not be nil here")
        tableView.dataSource = dataProvider
        dataProvider?.tableView = tableView
        
        setBalanceTitle()
    }
    
    func changeBudget() {
        let alertController = UIAlertController(title: "Balance", message: "Enter new balance", preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (_) in
            let balanceField = alertController.textFields![0] as UITextField
            if let balanceText = balanceField.text {
                let balanceStr = NSString(string: balanceText)
                let balanceDbl = balanceStr.doubleValue
                self.dataProvider?.budget?.balance = NSNumber(double: balanceDbl)
                self.setBalanceTitle()
            }
        }
        
        let deleteAction = UIAlertAction(title: "Clear", style: .Destructive) { (_) in
            self.dataProvider?.budget?.cache()
            let balanceField = alertController.textFields![0] as UITextField
            if let balanceText = balanceField.text {
                let balanceStr = NSString(string: balanceText)
                let balanceDbl = balanceStr.doubleValue
                do {
                try Budget.create(balanceDbl)
                }
                catch {
                    //todo: handle budget creation error
                }
                self.setBalanceTitle()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in
            
        }
        
        
        alertController.addTextFieldWithConfigurationHandler { (balanceField) in
            balanceField.placeholder = "balance"
            balanceField.keyboardType = .DecimalPad
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func updateBalance() {
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
