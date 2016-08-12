//
//  ActivityTypePickerTVC.swift
//  MyBudget
//
//  Created by Austin Emser on 8/7/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit
import CoreData

public class ActivityTypePickerTVC: CoreDataTableViewController {
    
    var selectedActivityTypeIndex: Int?
    var activityType: ActivityType?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
    }

    func setupFetchedResultsController() {
        let fetchRequest = NSFetchRequest(entityName: "ActivityType")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: ad.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.selectedActivityTypeIndex = indexPath.row
        tableView.reloadData()
        
        self.activityType = self.fetchedResultsController.objectAtIndexPath(indexPath) as? ActivityType
        
        
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let activityType = self.fetchedResultsController.objectAtIndexPath(indexPath) as! ActivityType
        
        if indexPath.row == selectedActivityTypeIndex {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        cell.textLabel?.text = activityType.name
        
        return cell
    }
    
}
