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
    
    public override func awakeFromNib() {
        NSNotificationCenter.defaultCenter().addObserverForName("BudgetAvailable", object: nil, queue: nil) { (note) in
            self.dataProvider = ActivityListDataProvider(budget: note.userInfo!["Budget"] as! Budget)
            self.setDataProvider()
        }
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setBalanceTitle()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(ActivityListTVC.changeBudget))
        var rightBarButtonItems = self.navigationItem.rightBarButtonItems
        rightBarButtonItems?.append(editButton)
        self.navigationItem.rightBarButtonItems = rightBarButtonItems
        
        assert(dataProvider != nil, "datasrouce should not be nil here")
        setDataProvider()
    }
    
    func setDataProvider() {
        tableView.dataSource = dataProvider
        dataProvider?.tableView = tableView
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
                    let budget = try Budget.create(balanceDbl)
                    budget.notifyNewBudget()
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
    
    func setBalanceTitle() {
        let balance = dataProvider?.budget?.balance?.currencyString
        self.navigationItem.title = balance
    }
    
    func updateBalance(newBalance: Double) {
        if let budget = dataProvider?.budget {
            budget.balance = newBalance
            ad.saveContext()
            setBalanceTitle()
        }
    }
    
    @IBAction func saveActivityDetailUnwindSegue(segue: UIStoryboardSegue) {
        if let activityDetailsTVC = segue.sourceViewController as? ActivityDetailsTVC {
            if let activityInfo = activityDetailsTVC.activityInfo {
                if let activity = activityDetailsTVC.activityToEdit {
                    activity.name = activityInfo.name
                    activity.amount = activityInfo.amount
                    activity.activityType = activityInfo.activityType
                    ad.saveContext()
                } else {
                    Activity.create(activityInfo)
                }
            }
        }
    }

    
    @IBAction func saveAccountDetail(segue: UIStoryboardSegue) {
        if let accountDetailsTVC = segue.sourceViewController as? AccountDetailsTVC {
            if let accountInfo = accountDetailsTVC.accountInfo {
                Account.create(accountInfo)
            }
        }
    }
    
    @IBAction func cancelUnwindSegue(segue: UIStoryboardSegue) {
        
    }

    func addActivity() {
        performSegueWithIdentifier("activityDetailsVC", sender: nil)
    }
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let activity = dataProvider?.fetchedResultsController!.objectAtIndexPath(indexPath) as! Activity
        performSegueWithIdentifier("activityDetailsVC", sender: activity)
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
}
