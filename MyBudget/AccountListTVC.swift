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
            self.dataProvider = AccountListDataProvider(budget: note.userInfo!["budget"] as! Budget)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(AccountListTVC.addAccount))
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(AccountListTVC.save))
        self.navigationItem.rightBarButtonItems = [addButton, saveButton]
    
    
        assert(dataProvider != nil, "datasrouce should not be nil here")
        tableView.dataSource = dataProvider
        dataProvider?.tableView = tableView
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
    
    func save() {
        
    }
    
}
