//
//  CustomNavigationBar.swift
//  MyBudget
//
//  Created by Austin Emser on 7/30/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit

class CustomNavigationBar: UINavigationBar {

    let backgroundCol: UIColor = UIColor(netHex: 0x707070)
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        self.backgroundColor = backgroundCol
    }
    

}
