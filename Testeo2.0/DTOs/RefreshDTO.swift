//
//  RefreshDTO.swift
//  Testeo2.0
//
//  Created by Usuario on 07/10/25.
//

import Foundation

struct RefreshRequest: Codable {
    let refreshToken: String
    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
}


struct RefreshResponse: Codable {
    let accessToken: String
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
