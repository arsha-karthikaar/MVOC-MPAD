//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Neethu Krishnan on 24/08/20.
//  Copyright © 2020 DDUKK. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var empNameTxt: UITextField!
    @IBOutlet weak var empListTableView: UITableView!
    
    // Data source for table view
    var empList: [Employee]?
    // To manage store update
    var selectedIndex: Int?
    // Managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up delegate and datasource for table view
        empListTableView.delegate = self
        empListTableView.dataSource = self
        // Fetch employee list from store
        fetchEmployeeList()
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
    private func fetchEmployeeList() {
        do {
            // Fetch employee list from store
            self.empList = try context.fetch(Employee.fetchRequest())
        } catch {
            print("Error in fetching")
        }
        DispatchQueue.main.async {
            print("Employee list:\(String(describing: self.empList))")
            // Reload table view with store data
            self.empListTableView.reloadData()
        }
    }
    
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
        if let employees = empList, !employees.isEmpty  {
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
        // Fetch the new list from store and update table view
        fetchEmployeeList()
    }
    
    private func updateEmplyeeToDB(empName: String) {
        guard let selIndex = selectedIndex else {
            showAlert(message: "Employee not in the list")
            return
        }
        // Get the employee object to update
        let empToUpdate = empList![selIndex]
        // Update employee name with the new name in the textfield
        empToUpdate.empName = empName
        do {
            try self.context.save()
        } catch {
            print("Error in updation")
        }
        fetchEmployeeList()
    }
    
    private func deleteEmployee(index: Int) {
        // Get the employee object to update
        let empToDelete = self.empList![index]
        // Delete the object
        self.context.delete(empToDelete)
        do {
            // Save it to the store
            try self.context.save()
        } catch {
            print("Error in deletion")
        }
        self.fetchEmployeeList()
    }
}

// MARK: UITableView Delegates and DataSource
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard empList != nil else {
            return 0
        }
        // Return the number of rows for table view
        return empList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell", for: indexPath) as! EmployeeTableViewCell
        // Set employee name in cell's label
        cell.bindData(empName: empList![indexPath.row].empName!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        empNameTxt.text = empList![indexPath.row].empName
        // Set selected index for store updation
        selectedIndex = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Swipe action for delete
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.deleteEmployee(index: indexPath.row)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}

