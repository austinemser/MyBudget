//
//  ActivityListDataSource.swift
//  MyBudget
//
//  Created by Austin Emser on 7/19/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit
import CoreData

public class ActivityListDataProvider: NSObject, ActivityListDataProviderProtocol  {
    public var managedObjectContext: NSManagedObjectContext?
    public var budget: Budget?
    weak public var tableView: UITableView!
    public var fetchedResultsController: NSFetchedResultsController? = nil
    
    init(budget: Budget) {
        self.budget = budget
        self.managedObjectContext = budget.managedObjectContext
    }
    
    public func fetch() {
        
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: false)
        let sortDescriptors = [sortDescriptor]
        
        _fetchedResultsController.fetchRequest.sortDescriptors = sortDescriptors
        do {
            try _fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("error :\(error)")
        }
        tableView.reloadData()
    }
    
    
    func configureCell(cell: ActivityCell, atIndexPath indexPath: NSIndexPath) {
        let activity = self._fetchedResultsController.objectAtIndexPath(indexPath) as! Activity
        cell.configureCell(activity)
    }
}

// MARK: UItableViewDataSource
// TODO: Abstract further
extension ActivityListDataProvider: UITableViewDataSource {
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self._fetchedResultsController.sections?.count ?? 0
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self._fetchedResultsController.sections![section]
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
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = self._fetchedResultsController.sections![section]
        return sectionInfo.name
    }
    
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = self._fetchedResultsController.managedObjectContext
            context.deleteObject(self._fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)
            
            do {
                try context.save()
            } catch let error as NSError {
                print("Delete Error \(error.localizedDescription)")
                abort()
            }
        }
    }
}

extension ActivityListDataProvider: NSFetchedResultsControllerDelegate {
    
    var _fetchedResultsController: NSFetchedResultsController {
        if fetchedResultsController != nil {
            return fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Activity", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        fetchRequest.predicate = NSPredicate(format: "budget = %@", self.budget!)
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: "sectionIdentifier", cacheName: nil)
        aFetchedResultsController.delegate = self
        fetchedResultsController = aFetchedResultsController
        
        do {
            try fetchedResultsController!.performFetch()
        } catch let error as NSError {
            print("performFetch error: \(error.localizedDescription)")
            
            abort()
        }
        
        return fetchedResultsController!
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






