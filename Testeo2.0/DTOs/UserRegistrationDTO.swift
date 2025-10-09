//
//  UserRegistrationDTO.swift
//  Testeo2.0
//
//  Created by Usuario on 08/10/25.
//

import Foundation

struct RegistrationRequest: Codable {
    var email: String
    var name: String
    var password: String
}


struct RegistrationFormRequest: Codable {
    var email: String
    var name: String
    var password: String
    var confirmPassword: String
    
}

