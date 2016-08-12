//
//  CoreDataTableViewController.swift
//  MyBudget
//
//  Created by Austin Emser on 8/11/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit
import CoreData

public class CoreDataTableViewController: UITableViewController {
    private var _fetchedResultsController: NSFetchedResultsController!
    var fetchedResultsController: NSFetchedResultsController {
        set {
            if _fetchedResultsController != newValue {
                _fetchedResultsController = newValue
                _fetchedResultsController.delegate = self
                fetch()
            }
        } get {
            return _fetchedResultsController
        }
    }
    
    func fetch() {
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            
        }
    }
    
}

// MARK : UITableViewDataSource

extension CoreDataTableViewController {
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    public override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.name
    }
    
    public override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
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

// MARK : NSFetchedResultsControllerDelegate

extension CoreDataTableViewController : NSFetchedResultsControllerDelegate {
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
            break
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    public func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
}
