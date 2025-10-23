import Foundation

struct PublicSearchItemDTO: Codable, Identifiable {
    // id sintético para ForEach; usamos url+createdAt si no hay ID real
    var id: String { (url ?? "") + "|" + (createdAt ?? UUID().uuidString) }

    let reporter: String?
    let url: String?
    let description: String?
    let imageURL: String?
    let category: String?
    let createdAt: String?  // puede no venir en /search (sí en /feed)

    enum CodingKeys: String, CodingKey {
        case reporter
        case url
        case description
        case imageURL = "image_url"
        case category
        case createdAt = "created_at"
    }
}
