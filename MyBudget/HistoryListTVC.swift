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
            self.setDataProvider()
        }
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setBalanceTitle()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setDataProvider()
    }
    
    func setDataProvider() {
        self.dataProvider?.tableView = tableView
        tableView.dataSource = dataProvider
    }
    
    func setBalanceTitle() {
        let balance = dataProvider?.user?.activeBudget?.balance?.currencyValue
        self.navigationItem.title = balance
    }
}
