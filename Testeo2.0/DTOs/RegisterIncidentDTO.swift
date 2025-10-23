//
//  RegisterIncidentDTO.swift
//  Testeo2.0
//
//  Created by Usuario on 09/10/25.
//

import Foundation

struct CreateReportRequest: Encodable {
    let pageURL: String
    let description: String
    let anonymous: Bool
    let categoryId: Int
    let files: [Data]
    
}

struct CreateReportResponse: Decodable {
    let id: Int
}
