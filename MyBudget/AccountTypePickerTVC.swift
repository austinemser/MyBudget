//
//  AccountTypePickerTVC.swift
//  MyBudget
//
//  Created by Austin Emser on 8/3/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit

class AccountTypePickerTVC: UITableViewController {
    
    let accountTypes = ["Credit", "Checking", "Savings", "401k"]
    
    var selectedAccountTypeIndex: Int? {
        didSet {
            let accountTypeIndex = Int32(selectedAccountTypeIndex!)
            self.accountType = AccountType(rawValue: accountTypeIndex)
        }
    }
    var accountType: AccountType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return accountTypes.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        if indexPath.row == selectedAccountTypeIndex {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        cell.textLabel?.text = accountTypes[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let index = selectedAccountTypeIndex {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            cell?.accessoryType = .None
        }
        
        selectedAccountTypeIndex = indexPath.row
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
