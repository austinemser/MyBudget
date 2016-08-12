//
// Created by Austin Emser on 8/8/16.
// Copyright (c) 2016 AustinEmser. All rights reserved.
//

import UIKit
import CoreData

public class ActivityTypeDataProvider: NSObject, ActivityTypeDataProviderProtocol {
    public var managedObjectContext: NSManagedObjectContext?
    weak public var tableView: UITableView!
    public var fetchedResultsController: NSFetchedResultsController?
    
    public func fetch() {
        do {
            try _fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("error :\(error)")
        }
        tableView.reloadData()
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let activityType = self._fetchedResultsController.objectAtIndexPath(indexPath) as! ActivityType
        cell.textLabel?.text = activityType.name
    }
}

extension ActivityTypeDataProvider : UITableViewDataSource {
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self._fetchedResultsController.sections?.count ?? 0
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self._fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
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

extension ActivityTypeDataProvider : NSFetchedResultsControllerDelegate {
    var _fetchedResultsController: NSFetchedResultsController {
        if fetchedResultsController != nil {
            return fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("ActivityType", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
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
            self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    public func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
}
