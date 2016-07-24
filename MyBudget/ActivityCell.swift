//
//  ActivityCell.swift
//  MyBudget
//
//  Created by Austin Emser on 7/23/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var activityTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(activity: Activity) {
        nameLabel.text = activity.name
        amountLabel.text = activity.amount?.stringValue
        activityTypeLabel.text = activity.activityType?.name
    }

}
