//
//  Extensions.swift
//  MyBudget
//
//  Created by Austin Emser on 7/30/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import Foundation

extension NSNumber {
    var currencyValue: String? {
        get {
            let formatter = NSNumberFormatter()
            formatter.locale = NSLocale(localeIdentifier: "en_US")
            formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            return formatter.stringFromNumber(self)
        }
    }
}
