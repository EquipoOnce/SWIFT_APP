import Foundation

struct ReportsAPI2 {
    private let baseURL = URL(string: "http://10.48.228.126:3000")! // ajusta si cambia
    private let executor = RequestExecutor()

    /// POST /reports -> { id }
    func createReport(_ dto: CreateReportRequest) async throws -> CreateReportResponse {
        let url = baseURL.appendingPathComponent("reports") // sin "/" inicial
        var req = URLRequest(url: url)
        req.httpMethod = "POST"

        // Multipart
        let boundary = "Boundary-\(UUID().uuidString)"
        req.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // --- función local para campos de texto ---
        func appendField(name: String, value: String) {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }

        // Campos (respeta nombres que espera tu backend)
        let trimmedURL = dto.pageURL.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedURL.isEmpty {
            appendField(name: "page_url", value: trimmedURL)
        }
        appendField(name: "description", value: dto.description)
        appendField(name: "categoryId", value: String(dto.categoryId))
        appendField(name: "anonymous", value: dto.anonymous ? "true" : "false")

        // Archivos (files[])
        for (idx, data) in dto.files.enumerated() {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"files[]\"; filename=\"photo\(idx+1).jpg\"\r\n")
            body.appendString("Content-Type: image/jpeg\r\n\r\n")
            body.append(data) // <-- este sí existe en Data
            body.appendString("\r\n")
        }

        // Cierre
        body.appendString("--\(boundary)--\r\n")
        req.httpBody = body

        let (data, http) = try await executor.send(req, requiresAuth: true)
        guard (200...299).contains(http.statusCode) else {
            let msg = String(data: data, encoding: .utf8) ?? "<sin cuerpo>"
            throw NSError(domain: "ReportsAPI", code: http.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: "Falló \(http.statusCode): \(msg)"])
        }
        return try JSONDecoder().decode(CreateReportResponse.self, from: data)
    }
}

// Helper necesario para usar appendString en Data
private extension Data {
    mutating func appendString(_ string: String) {
        if let d = string.data(using: .utf8) { append(d) }
    }
}
