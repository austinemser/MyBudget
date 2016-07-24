//
//  ActivityDetailsVC.swift
//  MyBudget
//
//  Created by Austin Emser on 7/22/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit
import CoreData

class ActivityDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var activityTypePicker: UIPickerView!
    @IBOutlet weak var nameField: CustomTextField!
    @IBOutlet weak var amountField: CustomTextField!
    @IBOutlet weak var newActivityTypeField: CustomTextField!
    
    var activityToEdit: Activity?
    var activityTypes = [ActivityType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let deleteButton = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: #selector(ActivityDetailsVC.deletePressed))
        self.navigationItem.rightBarButtonItem = deleteButton
        
        getActivityTypes()
        
        activityTypePicker.delegate = self
        activityTypePicker.dataSource = self
    }

    
    func getActivityTypes() {
        let fetchRequest = NSFetchRequest(entityName: "ActivityType")
        do {
            self.activityTypes = try ad.managedObjectContext.executeFetchRequest(fetchRequest) as! [ActivityType]
            self.activityTypePicker.reloadAllComponents()
        } catch {
            
        }
    }
    
    func deletePressed() {
        if let activity = activityToEdit {
            ad.managedObjectContext.deleteObject(activity)
            ad.saveContext()
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func savePressed() {
        var activity: Activity!
        
        if activityToEdit == nil {
            activity = NSEntityDescription.insertNewObjectForEntityForName("Activity", inManagedObjectContext: ad.managedObjectContext) as! Activity
        } else {
            activity = activityToEdit
        }
        
        if let name = nameField.text {
            activity.name = name
        }
        
        if let amount = amountField.text {
            let amountStr = NSString(string: amount)
            let amountDbl = amountStr.doubleValue
            activity.amount = amountDbl
        }
        
        activity.activityType = activityTypes[activityTypePicker.selectedRowInComponent(0)]
        
        ad.saveContext()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func createActivityTypePressed() {
        let activityType = NSEntityDescription.insertNewObjectForEntityForName("ActivityType", inManagedObjectContext: ad.managedObjectContext) as! ActivityType
        activityType.name = newActivityTypeField.text
        ad.saveContext()
        getActivityTypes()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return activityTypes.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let activityType = activityTypes[row]
        return activityType.name
    }
    
    
}
