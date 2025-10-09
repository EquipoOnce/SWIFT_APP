//
//  HTTPClient.swift
//  Testeo2.0
//
//  Created by Usuario on 06/10/25.
//

import Foundation

struct HTTPClient {
    
    func UserRegistration(_ request: RegistrationRequest) async throws {
        guard let url = URL(string: "http://10.48.228.126:3000/users") else {
            throw URLError(.badURL)
    }
        
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "POST"
        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        httpRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        httpRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, response) = try await URLSession.shared.data(for: httpRequest)
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(http.statusCode) else {
            let message = String(data: data, encoding: .utf8)
            throw NSError(domain: "HTTPClient",
                           code: http.statusCode,
                          userInfo: [NSLocalizedDescriptionKey : "Fallo \(http.statusCode): \(String(describing: message))"])
        }
    }
    
    func UserLogin(email:String, password:String) async throws -> LoginResponse{
        let loginReequest = LoginRequest(email:email, password:password)
        guard let url = URL(string: "http://10.48.228.126:3000/auth/login") else {
            throw URLError(.badURL)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(loginReequest)
        let (data,response) = try await URLSession.shared.data(for: urlRequest)  // regresa una data y un responce y hace la peticion a la nube
        
        if let httpresponse = response as? HTTPURLResponse{
            print("HTTP status: \(httpresponse.statusCode)")
        }
        print("Raw body:", String(data: data, encoding: .utf8) ?? "<no-body>")
        
        guard let httpresponse = response as? HTTPURLResponse,
              (200...299).contains(httpresponse.statusCode) else{
            throw URLError(.badServerResponse)
        }
        let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)   //201 es el exito de un post
        return loginResponse
    }
    
    func refreshAccessToken(refreshToken: String) async throws -> String{
        let refreshRequest = RefreshRequest(refreshToken: refreshToken)
        guard let url = URL(string: "http://10.48.228.122:3000/auth/refresh") else {
            throw URLError(.badURL)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(refreshRequest)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpresponse = response as? HTTPURLResponse,
              (200...299).contains(httpresponse.statusCode) else{
            throw URLError(.userAuthenticationRequired)
        }
        
        let decoded = try JSONDecoder().decode(RefreshResponse.self, from: data)
        return decoded.accessToken
        
        
    }
    
}
