//
//  LoginDTO.swift
//  Testeo2.0
//
//  Created by Usuario on 06/10/25.
//

import Foundation

struct LoginRequest:Codable{
    var email:String
    var password:String
    
}

struct LoginResponse : Codable{
    let accessToken,refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
