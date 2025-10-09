//
//  AuthenticationController.swift
//  Testeo2.0
//
//  Created by Usuario on 06/10/25.
//

import Foundation

struct AuthenticationController {
    let httpClient: HTTPClient
    
    func registerUser(request: RegistrationRequest) async throws {
        try await httpClient.UserRegistration(request)
    }
    
    func loginUser(email:String, password:String)
    async throws -> Bool {
        let loginResponse = try await httpClient.UserLogin(email:email, password: password)
        
        let AccessToken = TokenStorage.set(.access, value: loginResponse.accessToken)
        let RefreshToken = TokenStorage.set(.refresh, value: loginResponse.refreshToken)
        
        return AccessToken && RefreshToken
    }
    
    func getAccessToken() -> String? {
        TokenStorage.get(.access)
    }
    func getRefreshToken() -> String? {
        TokenStorage.get(.refresh)
    }
}

