import Foundation

struct TopDomainItemDTO: Codable, Identifiable {
    // Generamos un id estable con lo que venga
    var id: String { (url ?? "nil") + "|" + (category ?? "nil") }

    let category: String?
    let url: String?
}
