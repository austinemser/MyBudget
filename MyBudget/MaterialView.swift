//
//  MaterialView.swift
//  MyBudget
//
//  Created by Austin Emser on 7/22/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit

private var materialKey = false
extension UIView {
    
    @IBInspectable var materialDesign: Bool {
        get {
            return materialKey
        }
        set {
            materialKey = newValue
            
            if materialKey {
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowOffset  = CGSizeMake(0.0, 2.0)
                self.layer.shadowColor = UIColor(red: 157.0/255.0, green: 157.0/255.0, blue: 157.0/255.0, alpha: 1.0).CGColor
            } else {
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowColor = nil
            }
        }
    }
}