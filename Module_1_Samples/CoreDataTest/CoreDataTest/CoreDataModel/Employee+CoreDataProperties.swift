//
//  Employee+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Neethu Krishnan on 26/08/20.
//  Copyright © 2020 DDUKK. All rights reserved.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var empID: Int16
    @NSManaged public var empName: String?

}
