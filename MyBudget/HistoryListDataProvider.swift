//
//  HistoryListDataProvider.swift
//  MyBudget
//
//  Created by Austin Emser on 7/31/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit
import CoreData

public class HistoryListDataProvider: NSObject, HistoryListDataProviderProtocol {
    public var managedObjectContext: NSManagedObjectContext?
    public var user: User?
    weak public var tableView: UITableView!
    public var fetchedResultsController: NSFetchedResultsController? = nil

    init(user:User) {
        self.user = user
        self.managedObjectContext = user.managedObjectContext
    }

    public func fetch() {
        let sortDescriptor = NSSortDescriptor(key: "archived", ascending: false)
        let sortDescriptors = [sortDescriptor]

        _fetchedResultsController.fetchRequest.sortDescriptors = sortDescriptors
        do {
            try _fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("error :\(error)")
        }
        tableView.reloadData()
    }

    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let budget = self._fetchedResultsController.objectAtIndexPath(indexPath) as! Budget
        cell.textLabel?.text = budget.balance?.currencyString
        cell.detailTextLabel?.text = "\(budget.archived)"
    }
}

extension HistoryListDataProvider: UITableViewDataSource {

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

extension HistoryListDataProvider: NSFetchedResultsControllerDelegate {

    var _fetchedResultsController: NSFetchedResultsController {
        if fetchedResultsController != nil {
            return fetchedResultsController!
        }

        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Budget", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        fetchRequest.predicate = NSPredicate(format: "user = %@ and archived != nil", self.user!)
        fetchRequest.fetchBatchSize = 20

        let sortDescriptor = NSSortDescriptor(key: "archived", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
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