//: Playground - noun: a place where people can play
import Foundation

let data: Data

struct Organisation {
    struct Employee: Decodable {
        var designation: String
        var schedaTecnica: [String:String]?
        var description: String
        var iscrizione: String
        var materiali: String
        var notizieStoriche: String
        var image: String?
    }
    var employees: [Employee]
    
    init(employees: [Employee] = []) {
        self.employees = employees
    }
}

extension Organisation: Decodable {
    struct EmployeeKey: CodingKey {
        var stringValue: String
        var intValue: Int? { return nil }
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        init?(intValue: Int) {
            return nil
        }
        static let description = EmployeeKey(stringValue: "descrizione")
        static let schedaTecnica = EmployeeKey(stringValue: "scheda_tecnica")
        static let iscrizione = EmployeeKey(stringValue: "iscrizione")
        static let materiali = EmployeeKey(stringValue: "materiali")
        static let notizieStoriche = EmployeeKey(stringValue: "notizie_storiche")
        static let image = EmployeeKey(stringValue: "image")
    }
    
    public init(from decoder: Decoder) throws {
        var employees = [Employee]()
        let container = try decoder.container(keyedBy: EmployeeKey.self)
        for key in container.allKeys {
            
            let employeeContainer = try container.nestedContainer(keyedBy: EmployeeKey.self, forKey: key)
            
            let description = try employeeContainer.decode(String.self, forKey: EmployeeKey.description!)
            let schedaTecnica = try employeeContainer.decode([String: String].self, forKey: EmployeeKey.schedaTecnica!)
            let iscrizione = try employeeContainer.decode(String.self, forKey: EmployeeKey.iscrizione!)
            let materiali = try employeeContainer.decode(String.self, forKey: EmployeeKey.materiali!)
            let notizieStoriche = try employeeContainer.decode(String.self, forKey: EmployeeKey.notizieStoriche!)
            let image = try employeeContainer.decodeIfPresent(String.self, forKey: EmployeeKey.image!)
            
            let employee = Employee(designation: key.stringValue, schedaTecnica: schedaTecnica, description: description, iscrizione: iscrizione, materiali: materiali, notizieStoriche: notizieStoriche, image: image)
            employees.append(employee)
        }
        self.init(employees: employees)
    }
}


do {
    guard let fileUrl = Bundle.main.url(forResource: "document", withExtension: "json") else { fatalError() }
    data = try Data(contentsOf: fileUrl)
    
    //Decoder
    let decoder = JSONDecoder()
    if let decodedOrganisation = try? decoder.decode(Organisation.self, from: data) {
        print("Total number of employees: \(decodedOrganisation.employees.count)\n")
        for employee in decodedOrganisation.employees {
            print("\nDesignation: \(employee.designation)")
            if let schedaTecnicaDict = employee.schedaTecnica {
                print(schedaTecnicaDict)
            }
            print(employee.description, employee.iscrizione, employee.notizieStoriche)
            if let image = employee.image {
                print(image)
            }
            
        }
    }
} catch DecodingError.keyNotFound(let key, let context) {
    print(key, context)
} catch DecodingError.valueNotFound(let value, let context) {
    print(value, context)
} catch DecodingError.typeMismatch(let type, let context) {
    print(type, context)
}
