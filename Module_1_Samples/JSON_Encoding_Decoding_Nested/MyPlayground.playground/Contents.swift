import UIKit

struct Department: Codable {
    var deptID: Int
    var deptName: String
}

struct Employee: Codable {
    var empId: Int
    var empName: String
    var department: Department
    
    // Coding keys for Employee
    enum CodingKeys: String, CodingKey {
        case empId = "employee_ID"
        case empName = "employee_Name"
    }
    
    // Coding keys for Department
    enum DepartmentCodingKeys: String, CodingKey {
        case deptID = "dept_id"
        case deptName = "dept_name"
    }
    
    // Decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        empId = try container.decode(Int.self, forKey: .empId)
        empName = try container.decode(String.self, forKey: .empName)
        
        let deptContainer = try decoder.container(keyedBy: DepartmentCodingKeys.self)
        let deptID = try deptContainer.decode(Int.self, forKey: .deptID)
        let deptName = try deptContainer.decode(String.self, forKey: .deptName)
        department = Department(deptID: deptID, deptName: deptName)
    }
    
    // Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(empId, forKey: .empId)
        try container.encode(empName, forKey: .empName)
        
        var deptContainer = encoder.container(keyedBy: DepartmentCodingKeys.self)
        try deptContainer.encode(department.deptID, forKey: .deptID)
        try deptContainer.encode(department.deptName, forKey: .deptName)
    }
}

func decodeFromJSON() {

    // Sample JSON string
    let jsonStr = """
    {
        "employee_ID": 345,
        "employee_Name": "John",
        "location": "Chennai",
        "dept_id": 873,
        "dept_name": "Testing"
    }
    """

    // Convert json string to data
    let jsonData = jsonStr.data(using: .utf8)

    let decoder = JSONDecoder()
    // For converting from snake case to camel case only
    //decoder.keyDecodingStrategy = .convertFromSnakeCase
    do {
        // Decoding to Employee
        let employee = try decoder.decode(Employee.self, from: jsonData!)
        print("Decoded Employee Data: \(employee)")
        do {
            // Encoding to JSON from Employee
            let encodedJSON = try JSONEncoder().encode(employee)
            let jsonStr = String(data: encodedJSON, encoding: .utf8)
            print("Encoded JSON: \(jsonStr!)")
        } catch {
            print("Error in encoding: \(error.localizedDescription)")
        }
        
    } catch {
        print("Error in decoding:\(error.localizedDescription)")
    }
}

decodeFromJSON()
