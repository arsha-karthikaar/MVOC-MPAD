//
//  EmployeeTableViewCell.swift
//  CoreDataTest
//
//  Created by Neethu Krishnan on 25/08/20.
//  Copyright © 2020 DDUKK. All rights reserved.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {

    @IBOutlet weak var empName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bindData(empName: String) {
        self.empName.text = empName
    }
}
