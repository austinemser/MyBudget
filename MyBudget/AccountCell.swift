//
//  AccountCell.swift
//  MyBudget
//
//  Created by Austin Emser on 7/31/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {

    @IBOutlet weak var balanceTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(account: Account) {
        balanceTextField.text = "\(account.balance)"
    }
}
