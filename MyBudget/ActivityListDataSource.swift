//
//  ActivityListDataSource.swift
//  MyBudget
//
//  Created by Austin Emser on 7/19/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit
import CoreData

public class ActivityListDataSource: NSObject, ActivityListDataSourceProtocol  {
    public var managedObjectContext: NSManagedObjectContext?
    public var account: Account?
    weak public var tableView: UITableView!
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    init(account: Account) {
        self.account = account
        self.managedObjectContext = account.managedObjectContext
    }
    
    public func fetch() {
        let sortAscending = NSUserDefaults.standardUserDefaults().integerForKey("sort") == 0 ? true : false
        
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: sortAscending)
        let sortDescriptors = [sortDescriptor]
        
        fetchedResultsController.fetchRequest.sortDescriptors = sortDescriptors
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("error :\(error)")
        }
        tableView.reloadData()
    }
    
    public func addActivity(activity: Activity) {
        //TODO:
    }
    
    func configureCell(cell: ActivityCell, atIndexPath indexPath: NSIndexPath) {
        let activity = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Activity
        cell.configureCell(activity)
    }
}

// MARK: UItableViewDataSource
// Could be abstracted, it is all generic
extension ActivityListDataSource: UITableViewDataSource {
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ActivityCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)
            
            do {
                try context.save()
            } catch let error as NSError {
                print("Delete Error \(error.localizedDescription)")
                abort()
            }
        }
        
    }
}

extension ActivityListDataSource: NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Activity", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        fetchRequest.predicate = NSPredicate(format: "account = %@", self.account!)
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch let error as NSError {
            print("performFetch error: \(error.localizedDescription)")
            
            abort()
        }
        
        return _fetchedResultsController!
    }
    
    public func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    public func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    public func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            self.configureCell(tableView.cellForRowAtIndexPath(indexPath!) as! ActivityCell, atIndexPath: indexPath!)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    public func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
}






