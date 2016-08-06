//
//  AccountCell.swift
//  MyBudget
//
//  Created by Austin Emser on 7/31/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit

public class AccountCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var accountTypeLabel: UILabel!
    @IBOutlet weak var creditLimitLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(account: Account) {
        nameLabel.text = account.name
        accountTypeLabel.text = "\(account.accountType)"
        creditLimitLabel.text = account.creditLimit?.currencyString
        balanceLabel.text = account.balance?.currencyString
    }
    
}
