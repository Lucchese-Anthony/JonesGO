//
//  URLSesssionManager.swift
//  codefest-ejai-ios
//
//  Created by Charles Faquin on 10/12/23.
//

import Foundation

struct URLSessionManager {
    
    private var session: URLSession
    
    static let url = "https://jonesgo.greenocean-997bc9d2.southcentralus.azurecontainerapps.io/"
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func makeRequest<T: Decodable>(_ model: T.Type, path: Path?, method: HTTPMethod, body: Data?) async throws -> T {
        let urlPath = path?.rawValue ?? ""
        guard let url = URL(string: "https://jonesgo.greenocean-997bc9d2.southcentralus.azurecontainerapps.io/" + urlPath) else { throw URLError(.badURL) }
        var req = URLRequest(url: url)
        req.httpBody = body
        req.httpMethod = method.rawValue
        let (data, response) = try await session.data(for: req)
        print(req)
        let pretty = String(data: data, encoding: .utf8)
        print(pretty!)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            // You could further refine this by creating custom error types
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    enum Path: String {
        case users
        case scores
        case points
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
}


