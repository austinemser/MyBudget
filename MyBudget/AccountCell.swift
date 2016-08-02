//
//  AccountCell.swift
//  MyBudget
//
//  Created by Austin Emser on 7/31/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit

public class AccountCell: UITableViewCell {

    @IBOutlet weak var balanceTextField: UITextField!
    @IBOutlet weak var saveButton: AccountCellSaveButton!
    public var account: Account?
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        balanceTextField.keyboardType = .DecimalPad
        balanceTextField.textAlignment = .Right
    }
    
    func configureCell(account: Account) {
        self.account = account
        self.saveButton.accountCell = self
        balanceTextField.text = account.balance?.stringValue
    }
    
}
