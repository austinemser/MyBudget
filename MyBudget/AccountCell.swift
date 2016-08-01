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
    @IBOutlet weak var saveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        balanceTextField.keyboardType = .DecimalPad
        balanceTextField.textAlignment = .Right
    }
    
    func configureCell(account: Account) {
        balanceTextField.text = account.balance?.stringValue

    }
    
}
