//: Playground - noun: a place where people can play
import Foundation

let data: Data

struct Organisation {
    struct Employee: Decodable {
        var designation: String
        var scheda_tecnica: [String:String]?
        var descrizione: String
        var iscrizione: String
        var materiali: String
        var notizie_storiche: String?
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
        static let descrizione = EmployeeKey(stringValue: "descrizione")
        static let scheda_tecnica = EmployeeKey(stringValue: "scheda_tecnica")
        static let iscrizione = EmployeeKey(stringValue: "iscrizione")
        static let materiali = EmployeeKey(stringValue: "materiali")
        static let notizie_storiche = EmployeeKey(stringValue: "notizie_storiche")
        static let image = EmployeeKey(stringValue: "image")
    }
    
    public init(from decoder: Decoder) throws {
        var employees = [Employee]()
        let container = try decoder.container(keyedBy: EmployeeKey.self)
        for key in container.allKeys {
            
            let employeeContainer = try container.nestedContainer(keyedBy: EmployeeKey.self, forKey: key)
            
            let descrizione = try employeeContainer.decode(String.self, forKey: EmployeeKey.descrizione!)
            let scheda_tecnica = try employeeContainer.decode([String: String].self, forKey: EmployeeKey.scheda_tecnica!)
            let iscrizione = try employeeContainer.decode(String.self, forKey: EmployeeKey.iscrizione!)
            let materiali = try employeeContainer.decode(String.self, forKey: EmployeeKey.materiali!)
            let notizie_storiche = try employeeContainer.decode(String.self, forKey: EmployeeKey.notizie_storiche!)
            let image = try employeeContainer.decode(String.self, forKey: EmployeeKey.image!)
            
            let employee = Employee(designation: key.stringValue, scheda_tecnica: scheda_tecnica, descrizione: descrizione, iscrizione: iscrizione, materiali: materiali, notizie_storiche: notizie_storiche, image: image)
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
        for employee in decodedOrganisation.employees {
            print(employee.designation, employee.descrizione, employee.iscrizione, employee.scheda_tecnica, employee.image, employee.notizie_storiche)
            
        }
    }
} catch DecodingError.keyNotFound(let key, let context) {
    print(key, context)
} catch DecodingError.valueNotFound(let value, let context) {
    print(value, context)
} catch DecodingError.typeMismatch(let type, let context) {
    print(type, context)
}
