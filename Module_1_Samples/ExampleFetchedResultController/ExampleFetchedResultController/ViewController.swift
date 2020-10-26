//
//  ViewController.swift
//  ExampleFetchedResultController
//
//  Created by Neethu Krishnan on 26/08/20.
//  Copyright © 2020 DDUKK. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var empNameTxt: UITextField!
    @IBOutlet weak var empListTableView: UITableView!
    
    // Configure fetch result controller
    lazy var fetchedResultController: NSFetchedResultsController<Employee> =  {
        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        
        let sortDescriptor = NSSortDescriptor(key: "empName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            print("Error in fetching")
        }
        return controller
    }()
    
   
    // To manage store update
    var selectedIndex: Int?
  
    // Managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up delegate and datasource for table view
        empListTableView.delegate = self
        empListTableView.dataSource = self
    }
    
    // MARK: IBActions
    @IBAction func updateEmployee(_ sender: Any) {
        guard let empName = empNameTxt.text, !empName.isEmpty else {
            showAlert(message: "Employee name can not be empty")
            return
        }
        updateEmplyeeToDB(empName: empName)
        empNameTxt.text = ""
    }
    
    @IBAction func addEmployee(_ sender: Any) {
        guard let empName = empNameTxt.text, !empName.isEmpty else {
            showAlert(message: "Employee name can not be empty")
            return
        }
        addEmployeeToDB(empName: empName)
        empNameTxt.text = ""
    }
    
    // MARK: Private Methods
    // To show alert
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addEmployeeToDB(empName: String) {
        // Create new NSManagedObject for Employee
        let employee = Employee(context: context)
        employee.empName = empName
        
        if let employees = fetchedResultController.fetchedObjects, !employees.isEmpty  {
            // Dynamically generate employee id
            employee.empID = Int16(employees.count + 1)
        } else {
            // Set employee id for the first time
            employee.empID = 1
        }
        
        do {
            // Save object to store
            try context.save()
        } catch {
            print("Error in saving")
        }
    }
    
    private func updateEmplyeeToDB(empName: String) {
        guard let selIndex = selectedIndex else {
            showAlert(message: "Employee not in the list")
            return
        }
        
        guard let employees = fetchedResultController.fetchedObjects else {
            showAlert(message: "Employee list not available")
            return
        }
        
        // Get the employee object to update
        let empToUpdate = employees[selIndex]
        // Update employee name with the new name in the textfield
        empToUpdate.empName = empName
        do {
            try self.context.save()
        } catch {
            print("Error in updation")
        }
    }
    
    private func deleteEmployee(indexPath: IndexPath) {
        // Get the employee object to update
        let empToDelete = fetchedResultController.object(at: indexPath)
        // Delete the object
        self.context.delete(empToDelete)
        do {
            // Save it to the store
            try self.context.save()
        } catch {
            print("Error in deletion")
        }
    }
}

// MARK: UITableView Delegates and Datasource
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let employees = fetchedResultController.fetchedObjects else {
            return 0
        }
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell", for: indexPath) as! EmployeeTableViewCell
        cell.bindData(empName: fetchedResultController.object(at: indexPath).empName!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        empNameTxt.text = fetchedResultController.object(at: indexPath).empName!
        // Set selected index for store updation
        selectedIndex = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Swipe action for delete
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.deleteEmployee(indexPath: indexPath)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}

// MARK: FetchedResults Controller Delegates
extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        empListTableView.reloadData()
    }
}
