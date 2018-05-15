//: Playground - noun: a place where people can play

import Foundation

do {
    guard let fileUrl = Bundle.main.url(forResource: "document", withExtension: "json") else { fatalError() }
    let data = try Data(contentsOf: fileUrl)

    struct Employee: Decodable {
        let arcoDi_Traiano: ArcoDiTraiano
        let tester: Tester
        
        //Adding Coding keys, since the string values are different in JSON
        private enum CodingKeys: String, CodingKey {
            case arcoDi_Traiano = "ArcoDiTraiano"
            case tester = "Tester"
        }
    }
    struct ArcoDiTraiano: Decodable {
        var scheda_tecnica: [String:String]?
        var descrizione: String
        var iscrizione: String
        var materiali: String
        var notizie_storiche: String
        var image: String
    }
    
    struct Tester: Decodable {
        var scheda_tecnica: [String:String]?
        var descrizione: String
        var iscrizione: String
        var materiali: String
        var notizie_storiche: String
        var image: String
    }
    
    //Decoder
    let decoder = JSONDecoder()
    if let emp = try? decoder.decode(Employee.self, from: data) {
        print(emp.arcoDi_Traiano.descrizione)
    }
    
} catch {
    print(error)
}
