//
//  ActivityDetailsTVC.swift
//  MyBudget
//
//  Created by Austin Emser on 8/7/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit

class ActivityDetailsTVC: UITableViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var detailsLabel: UILabel!
    
    var activityToEdit: Activity?
    var activityType: ActivityType?
    var activityInfo: ActivityInfo? {
        get {
            var amount: NSNumber?
            if let amountTxt = amountField.text {
                if let amountDbl = Double(amountTxt) {
                    amount = NSNumber(double: amountDbl)
                }
            }
            
            return ActivityInfo(amount: amount, name: nameField.text, activityType: activityType, budget: ad.getDefaultUser()?.activeBudget)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateData()
    }
    
    func populateData() {
        if let activity = activityToEdit {
            nameField.text = activity.name
            amountField.text = activity.amount?.stringValue
            detailsLabel.text = activity.activityType?.name
            activityType = activity.activityType
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

}
