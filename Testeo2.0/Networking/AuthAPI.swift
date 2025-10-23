//
//  AutAPI.swift
//  FraudX
//
//  Created by Iker on 22/10/25.
//

import Foundation	


struct AuthAPI {
    // AJUSTA si tu base cambia
    private let baseURL = URL(string: "http://10.48.251.159:3000")!

    /// POST /auth/logout  (body: { token: <refresh> })
    func logout(accessToken: String, refreshToken: String) async throws {
        let url = baseURL.appendingPathComponent("auth/logout")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let body = ["token": refreshToken]
        req.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        // éxito sin cuerpo
        if http.statusCode == 204 { return }

        // éxito con cuerpo JSON
        if (200...299).contains(http.statusCode) {
            if !data.isEmpty {
                _ = try? JSONDecoder().decode(LogoutResponse.self, from: data)
            }
            return
        }

        // error: intenta mostrar mensaje del backend
        let serverMsg = String(data: data, encoding: .utf8) ?? "Unknown server error"
        throw NSError(domain: "Logout", code: http.statusCode,
                      userInfo: [NSLocalizedDescriptionKey: serverMsg])
    }
}
