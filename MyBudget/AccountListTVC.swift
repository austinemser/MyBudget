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
    
    public override func awakeFromNib() {
        NSNotificationCenter.defaultCenter().addObserverForName("BudgetAvailable", object: nil, queue: nil) { (note) in
            self.dataProvider = AccountListDataProvider(budget: note.userInfo!["Budget"] as! Budget)
            self.setDataProvider()
        }
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setBalanceTitle()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(AccountListTVC.addAccount))
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(AccountListTVC.changeBudget))
        self.navigationItem.rightBarButtonItems = [addButton,editButton]
    
        
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
        let balance = dataProvider?.budget?.balance?.currencyValue
        self.navigationItem.title = balance
    }
    
    func addAccount() {

        let alertController = UIAlertController(title: "New Account", message: "Enter account name", preferredStyle: .Alert)
        let createAction = UIAlertAction(title: "Create", style: .Default) { (_) in
            let nameField = alertController.textFields![0] as UITextField
            if let name = nameField.text {
                Account.create(0, name: name, budget: self.dataProvider!.budget!)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Destructive) { (_) in
        
        }
        alertController.addTextFieldWithConfigurationHandler { (nameField) in
            nameField.placeholder = "name"

        }
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
}
