import Foundation

struct ReportsAPI{
    private let baseURL = URL(string: "http://10.48.250.163:3000")!
    private let executor = RequestExecutor()


    func createReport(_ dto: CreateReportRequest) async throws -> CreateReportResponse {
        let url = baseURL.appendingPathComponent("reports")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"

        
        let boundary = "Boundary-\(UUID().uuidString)"
        req.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")

        var body = Data()

        
        func appendField(name: String, value: String) {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }

        
        let trimmedURL = dto.pageURL.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedURL.isEmpty {
            appendField(name: "page_url", value: trimmedURL)
        }
        appendField(name: "description", value: dto.description)
        appendField(name: "categoryId", value: String(dto.categoryId))
        appendField(name: "anonymous", value: dto.anonymous ? "true" : "false")

        
        for (idx, data) in dto.files.enumerated() {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"files\"; filename=\"photo\(idx+1).jpg\"\r\n")
            body.appendString("Content-Type: image/jpeg\r\n\r\n")
            body.append(data)
            body.appendString("\r\n")
        }

        
        body.appendString("--\(boundary)--\r\n")
        req.httpBody = body
        
        

        	
        let (data, http) = try await executor.send(req, requiresAuth: true)
        
        print("Respuesta HTTP:", http.statusCode)
        if let responseBody = String(data: data, encoding: .utf8) {
            print("Respuesta JSON:", responseBody)
        }
        guard (200...299).contains(http.statusCode) else {
            let msg = String(data: data, encoding: .utf8) ?? "<sin cuerpo>"
            throw NSError(domain: "ReportsAPI", code: http.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: "Falló \(http.statusCode): \(msg)"])
        }
        return try JSONDecoder().decode(CreateReportResponse.self, from: data)
    }
    
    func fetchPendingReports() async throws -> [ReportHistoryItem] {
            try await fetchReportsByStatus("pending")
        }

    func fetchValidatedReports() async throws -> [ReportHistoryItem] {
        try await fetchReportsByStatus("validated")
    }

    func fetchRejectedReports() async throws -> [ReportHistoryItem] {
        try await fetchReportsByStatus("rejected")
    }
    
    private func fetchReportsByStatus(_ status: String) async throws -> [ReportHistoryItem] {
            guard var components = URLComponents(string: "\(baseURL)/reports") else {
                throw URLError(.badURL)
            }

            components.queryItems = [URLQueryItem(name: "status", value: status)]
            guard let url = components.url else {
                throw URLError(.badURL)
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            let (data, _) = try await executor.send(request, requiresAuth: true)
            return try JSONDecoder().decode([ReportHistoryItem].self, from: data)
        }
    
    func fetchReportDetail(id: Int) async throws -> ReportDetailDTO {
        let url = baseURL.appendingPathComponent("reports/\(id)")
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, _) = try await executor.send(req, requiresAuth: true)
        return try JSONDecoder().decode(ReportDetailDTO.self, from: data)
    }
    
    func updateReport(id: Int, body: UpdateReportRequest, imageJPEG: Data?) async throws {
            let url = baseURL.appendingPathComponent("reports/\(id)")
            var req = URLRequest(url: url)
            req.httpMethod = "PATCH"

            let boundary = "Boundary-\(UUID().uuidString)"
            req.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            req.setValue("application/json", forHTTPHeaderField: "Accept")

            var httpBody = Data()

            func appendField(name: String, value: String) {
                httpBody.appendString("--\(boundary)\r\n")
                httpBody.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
                httpBody.appendString("\(value)\r\n")
            }

            // Campos opcionales
            if let v = body.pageURL { appendField(name: "page_url", value: v) }
            if let v = body.description { appendField(name: "description", value: v) }
            if let v = body.categoryId { appendField(name: "categoryId", value: String(v)) }
            if let v = body.deletePhoto { appendField(name: "deletePhoto", value: v ? "true" : "false") }

            // Imagen opcional (en el back aceptan 'file' o 'files'; usamos 'file')
            if let imageJPEG = imageJPEG {
                httpBody.appendString("--\(boundary)\r\n")
                httpBody.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"photo.jpg\"\r\n")
                httpBody.appendString("Content-Type: image/jpeg\r\n\r\n")
                httpBody.append(imageJPEG)
                httpBody.appendString("\r\n")
            }

            httpBody.appendString("--\(boundary)--\r\n")
            req.httpBody = httpBody

            // 204 esperado si todo ok (puede variar según back)
            let (data, http) = try await executor.send(req, requiresAuth: true)
            guard (200...299).contains(http.statusCode) else {
                let msg = String(data: data, encoding: .utf8) ?? "<sin cuerpo>"
                throw NSError(domain: "ReportsAPI.updateReport", code: http.statusCode,
                              userInfo: [NSLocalizedDescriptionKey: "Falló \(http.statusCode): \(msg)"])
            }
        }
    
    func publicSearch(domain: String? = nil,
                      url: String? = nil,
                      categoryId: Int? = nil,
                      order: String = "newest",
                      limit: Int = 50,
                      offset: Int = 0) async throws -> [PublicSearchItemDTO] {
        var comps = URLComponents(url: baseURL.appendingPathComponent("public/reports/search"),
                                      resolvingAgainstBaseURL: false)!
        var q: [URLQueryItem] = [URLQueryItem(name: "order", value: order),
                                URLQueryItem(name: "limit", value: String(limit)),
                                URLQueryItem(name: "offset", value: String(offset))]
        if let domain, !domain.isEmpty { q.append(URLQueryItem(name: "domain", value: domain)) }
        if let url, !url.isEmpty { q.append(URLQueryItem(name: "url", value: url)) }
        if let cid = categoryId { q.append(URLQueryItem(name: "categoryId", value: String(cid))) }
        comps.queryItems = q

        var req = URLRequest(url: comps.url!)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, _) = try await executor.send(req, requiresAuth: false)
        return try JSONDecoder().decode([PublicSearchItemDTO].self, from: data)
    }
    
    func publicFeed(order: String = "newest",
                    limit: Int = 50,
                    offset: Int = 0,
                    windowDays: Int = 180) async throws -> [PublicSearchItemDTO] {

        let base = URL(string: "http://10.48.251.159:3000")!
        var comps = URLComponents(url: base.appendingPathComponent("public/reports/feed"),
                                      resolvingAgainstBaseURL: false)!
        comps.queryItems = [
            URLQueryItem(name: "order", value: order),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "window", value: String(windowDays))
        ]

        var req = URLRequest(url: comps.url!)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, _) = try await executor.send(req, requiresAuth: false)

        return try JSONDecoder().decode([PublicSearchItemDTO].self, from: data)
    }
    
    func fetchTopDomains(windowDays: Int = 30,
                            limit: Int = 10,
                            offset: Int = 0) async throws -> [TopDomainItemDTO] {

        let base = URL(string: "http://10.48.251.159:3000")!
        var comps = URLComponents(url: base.appendingPathComponent("public/reports/domains"),
                                    resolvingAgainstBaseURL: false)!
        comps.queryItems = [
            URLQueryItem(name: "window", value: String(windowDays)),
            URLQueryItem(name: "limit",  value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset))
        ]

        var req = URLRequest(url: comps.url!)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Accept")

        let executor = RequestExecutor()
        let (data, _) = try await executor.send(req, requiresAuth: false)

        return try JSONDecoder().decode([TopDomainItemDTO].self, from: data)
    }
    
    
}

private extension Data {
    mutating func appendString(_ string: String) {
        if let d = string.data(using: .utf8) { append(d) }
    }
}

extension ReportsAPI {
    func deleteReport(id: Int) async throws {
        let url = baseURL.appendingPathComponent("reports/\(id)")
        var req = URLRequest(url: url)
        req.httpMethod = "DELETE"
        req.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, http) = try await executor.send(req, requiresAuth: true)
        guard (200...299).contains(http.statusCode) else {
            let msg = String(data: data, encoding: .utf8) ?? "<sin cuerpo>"
            throw NSError(domain: "ReportsAPI.deleteReport", code: http.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: "Falló \(http.statusCode): \(msg)"])
        }
    }
}



//https://sitio.com
