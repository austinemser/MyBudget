//
//  AccountDetailsTVC.swift
//  MyBudget
//
//  Created by Austin Emser on 8/3/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit

class AccountDetailsTVC: UITableViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var balanceField: UITextField!
    @IBOutlet weak var creditLimitField: UITextField!
    @IBOutlet weak var detailLabel: UILabel!
    
    var accountType: AccountType? {
        didSet {
            detailLabel?.text = "\(accountType?.hashValue)"
        }
    }
    
    var newAccount = false
    
    var accountInfo: AccountInfo? {
        get {
            var balance: NSNumber?
            if let balanceTxt = balanceField.text {
                if let balanceDbl = Double(balanceTxt) {
                    balance = NSNumber(double: balanceDbl)
                }
            }
            
            var name: String?
            if let nameTxt = nameField.text {
                name = nameTxt
            }
            
            var creditLimit: NSNumber?
            if let creditLimitTxt = creditLimitField.text {
                if let creditLimitDbl = Double(creditLimitTxt) {
                    creditLimit = Double(creditLimitDbl)
                }
            }
            
            return AccountInfo(balance: balance, name: name, accountType: nil, creditLimit: creditLimit, user: ad.getDefaultUser())
        }
        set {
            if let _accountInfo = newValue {
                nameField.text = _accountInfo.name
                balanceField.text = _accountInfo.balance?.stringValue
                creditLimitField.text = _accountInfo.creditLimit?.stringValue
            } else {
                newAccount = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //TODO: ?
    }
 
    @IBAction func unwindWithSelectedAccountType(segue: UIStoryboardSegue) {
        if let accountTypePickerTVC = segue.sourceViewController as? AccountTypePickerTVC,
            accountType = accountTypePickerTVC.accountType {
            self.accountType = accountType
        }
    }
}




