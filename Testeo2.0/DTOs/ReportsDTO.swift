import Foundation

struct ReportHistoryItem: Codable, Identifiable {
    let id: Int
    let status: String
    let description: String
    let createdAt: String
    let category: String

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case description
        case createdAt = "created_at"
        case category
    }
}


