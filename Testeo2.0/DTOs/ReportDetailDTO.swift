//
//  ReportDetailDTO.swift
//  Testeo2.0
//
//  Created by Martín Monroy Cuenca on 11/10/25.
//

import Foundation

struct ReportDetailDTO: Codable{
    
    let pageURL: String?
    let description: String?
    let anonymous: Bool?
    let category: String?
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case pageURL = "page_url"
        case description
        case anonymous
        case category
        case image
    }
}
