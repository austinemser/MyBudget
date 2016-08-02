//
//  BudgetNavigationController.swift
//  MyBudget
//
//  Created by Austin Emser on 7/31/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit

//TODO: add protocol

class BudgetNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addRightItemButtons(items: [UIBarButtonItem]) {
        let editBudget = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(BudgetNavigationController.changeBudget))
        var newItems = [editBudget]
        newItems.appendContentsOf(items)
        self.navigationItem.rightBarButtonItems = newItems
    }
    
    func changeBudget() {
        let alertController = UIAlertController(title: "Balance", message: "Enter new balance", preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (_) in
            let balanceField = alertController.textFields![0] as UITextField
            if let balanceText = balanceField.text {
                let balanceStr = NSString(string: balanceText)
                let balanceDbl = balanceStr.doubleValue
                //TODO: Some kind of delegate method call or notification post
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Destructive) { (_) in
            
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
