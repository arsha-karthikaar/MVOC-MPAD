//
//  EmployeeTableViewCell.swift
//  ExampleFetchedResultController
//
//  Created by Neethu Krishnan on 27/08/20.
//  Copyright © 2020 DDUKK. All rights reserved.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {

    @IBOutlet weak var empName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindData(empName: String) {
        self.empName.text = empName
    }

}
