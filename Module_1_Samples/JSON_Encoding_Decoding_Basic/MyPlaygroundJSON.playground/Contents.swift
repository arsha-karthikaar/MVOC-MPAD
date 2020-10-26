import UIKit

struct Employee: Codable {
    var empID:Int
    var empName:String
    var location:String

    // Coding Keys for Employee
    enum CodingKeys: String, CodingKey {
        case empID = "employee_ID"
        case empName = "employee_name"
        case location
    }
}

func encodeToJSON() {
    // Sample Employee object
    let employee = Employee(empID: 121, empName: "Jack", location: "Delhi")
    
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    do {
        // Encode to JSON data
        let jsonData = try encoder.encode(employee)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("Encoded JSON: \(jsonString)")
        }
    } catch {
        print(error.localizedDescription)
    }
}

func decodeJSON() {

    // Sample JSON string
    let jsonString = """
    {
        "employee_ID": 651,
        "employee_name": "Dan",
        "location": "Chennai"
    }
    """

    if let jsonData = jsonString.data(using: .utf8) {
        do {
            // Decode Employee from JSON
            let employee = try JSONDecoder().decode(Employee.self, from: jsonData)
            print("Decoded Employee: \(employee)")
        } catch {
            print(error.localizedDescription)
        }


    } else {
        print("Not a valid JSON")
    }

}

encodeToJSON()
decodeJSON()


