//
//  Extensions.swift
//  MyBudget
//
//  Created by Austin Emser on 7/30/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit

extension NSNumber {
    var currencyString: String? {
        get {
            let formatter = NSNumberFormatter()
            formatter.locale = NSLocale(localeIdentifier: "en_US")
            formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            return formatter.stringFromNumber(self)
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

//extension UINavigationController {
//    func changeBudget(budget: Budget) {
//        let alertController = UIAlertController(title: "Balance", message: "Enter new balance", preferredStyle: .Alert)
//        let saveAction = UIAlertAction(title: "Save", style: .Default) { (_) in
//            let balanceField = alertController.textFields![0] as UITextField
//            if let balanceText = balanceField.text {
//                let balanceStr = NSString(string: balanceText)
//                let balanceDbl = balanceStr.doubleValue
//                budget.balance = NSNumber(double: balanceDbl)
//            }
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Destructive) { (_) in
//            
//        }
//        alertController.addTextFieldWithConfigurationHandler { (balanceField) in
//            balanceField.placeholder = "balance"
//            balanceField.keyboardType = .DecimalPad
//        }
//        
//        alertController.addAction(saveAction)
//        alertController.addAction(cancelAction)
//        self.presentViewController(alertController, animated: true, completion: nil)
//    }
//    
//    func addRightBarButtonItem(barButtonItem: UIBarButtonItem) {
//        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(changeBudget))
//        self.navigationItem.rightBarButtonItems = [barButtonItem,editButton]
//    }
//}