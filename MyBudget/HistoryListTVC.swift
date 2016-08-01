//
//  HistoryListTVC.swift
//  MyBudget
//
//  Created by Austin Emser on 7/31/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit

public class HistoryListTVC: UITableViewController {

    public var dataProvider: HistoryListDataProviderProtocol?
    
    public override func awakeFromNib() {
        NSNotificationCenter.defaultCenter().addObserverForName("BudgetAvailable", object: nil, queue: nil) { (note) in
            let budget =  note.userInfo!["Budget"] as! Budget
            self.dataProvider = HistoryListDataProvider(user: budget.user!)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataProvider?.tableView = tableView
        tableView.dataSource = dataProvider
        
        setBalanceTitle()
    }
    
    func setBalanceTitle() {
        let balance = dataProvider?.user?.activeBudget?.balance?.currencyValue
        self.navigationItem.title = balance
    }
}
