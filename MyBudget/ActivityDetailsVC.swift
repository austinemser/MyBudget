//
//  ActivityDetailsVC.swift
//  MyBudget
//
//  Created by Austin Emser on 7/22/16.
//  Copyright © 2016 AustinEmser. All rights reserved.
//

import UIKit
import CoreData

protocol ActivityDetailsVCDelegate : class {
    func updateBalance()
}

class ActivityDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var activityTypePicker: UIPickerView!
    @IBOutlet weak var nameField: CustomTextField!
    @IBOutlet weak var amountField: CustomTextField!
    @IBOutlet weak var newActivityTypeField: CustomTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var activityToEdit: Activity?
    var activityTypes = [ActivityType]()
    var delegate:ActivityDetailsVCDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize.height = 750
        
        activityTypePicker.delegate = self
        activityTypePicker.dataSource = self
        
        
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: #selector(ActivityDetailsVC.deletePressed))
        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(ActivityDetailsVC.saveActivity))
        self.navigationItem.rightBarButtonItems = [saveButton,deleteButton]
        
        getActivityTypes()
        
        populateData()
    }

    func populateData() {
        if let activity = activityToEdit {
            nameField.text = activity.name
            amountField.text = activity.amount?.stringValue
            if let activityType = activity.activityType {
                if let activityTypeIndex = activityTypes.indexOf(activityType) {
                    activityTypePicker.selectRow(activityTypeIndex, inComponent: 0, animated: false)
                }
            }
        }
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
            delegate?.updateBalance()
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func saveActivity() {
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
        activity.budget = ad.getDefaultUser()?.activeBudget
        ad.saveContext()
        
        delegate?.updateBalance()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func savePressed() {
        self.saveActivity()
    }
    
    
    @IBAction func createActivityTypePressed() {
        if let newActivityTypeName = newActivityTypeField.text {
            ActivityType.create(newActivityTypeName)
            getActivityTypes()
        }
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
