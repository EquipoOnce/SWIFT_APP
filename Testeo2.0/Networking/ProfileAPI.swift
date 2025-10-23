//
//  ProfileAPI.swift
//  Testeo2.0
//
//  Created by Usuario on 07/10/25.
//

import Foundation

struct ProfileAPI{
    private let executor = RequestExecutor()
    
    func fetchMe() async throws -> PublicProfileDTO {
        guard let url = URL(string: "http://10.48.251.159:3000/users/me") else {
            throw URLError(.badURL)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, _) = try await executor.send(urlRequest, requiresAuth: true)
        
        return try JSONDecoder().decode(PublicProfileDTO.self, from: data)
    }
    
    func updateProfile(name: String?, email: String?) async throws {
        guard let url = URL(string: "http://10.48.251.159:3000/users/modify") else {
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let body = UpdateProfileRequest(name: name, email: email)
        urlRequest.httpBody = try JSONEncoder().encode(body)
        
        _ = try await executor.send(urlRequest, requiresAuth: true)
    }
    
    func updateProfileDiff(original: PublicProfileDTO, nuevoNombre: String?, nuevoEmail: String?) async throws {
        let namePatch: String? = (nuevoNombre != original.name) ? nuevoNombre : nil
        let emailPatch: String? = (nuevoEmail != original.email) ? nuevoEmail : nil
        
        guard namePatch != nil || emailPatch != nil else {
            return
        }
        
        try await updateProfile(name: namePatch, email: emailPatch)
    }
}
