//
//  AccountListTVC.swift
//  MyBudget
//
//  Created by Austin Emser on 7/30/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit

public class AccountListTVC: UITableViewController, UIAlertViewDelegate {

    public var dataProvider: AccountListDataProviderProtocol?
    
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setBalanceTitle()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(AccountListTVC.changeBudget))
        var rightBarButtonItems = self.navigationItem.rightBarButtonItems
        rightBarButtonItems?.append(editButton)
        self.navigationItem.rightBarButtonItems = rightBarButtonItems
    
        self.dataProvider = AccountListDataProvider(user: ad.getDefaultUser()!)
        
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
                self.dataProvider?.user?.activeBudget?.balance = NSNumber(double: balanceDbl)
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
    
    func setBalanceTitle() {
        let balance = dataProvider?.user?.activeBudget?.balance?.currencyString
        self.navigationItem.title = balance
    }
    
    @IBAction func saveAccountDetail(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func cancelAccountDetail(segue: UIStoryboardSegue) {
        
    }
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let account = self.dataProvider?.fetchedResultsController?.objectAtIndexPath(indexPath) as! Account
        performSegueWithIdentifier("accountDetailsSegue", sender: account)
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "accountDetailsSegue" {
            let navController = segue.destinationViewController as! UINavigationController
            let accountDetailsTVC = navController.viewControllers[0] as! AccountDetailsTVC
            let account = sender as? Account
            accountDetailsTVC.accountInfo = account?.accountInfo
        }
    }
}





