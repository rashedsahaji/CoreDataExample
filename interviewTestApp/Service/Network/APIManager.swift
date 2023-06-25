//
//  RESTManager.swift
//  moviedb
//
//  Created by Rashed Sahajee on 24/06/23.
//

import Foundation

// MARK: - Reduced Code
typealias NetworkResponseData = (data: Data, response: URLResponse)
typealias APIResponse = (data: Data, statusCode: Int)


final class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    // MARK: - Shared Common Header
    static var sharedHeaders : HTTPHeaders {
        ["Content-Type": "application/json"]
    }
    
    // MARK: - Properties
    private let session = URLSession.shared
    
    // MARK: - Common URLRequest Generator
 private func createRquest(from endPoint: EndPoint) async throws -> URLRequest {
        guard
            let url = endPoint.url,
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw CustomErrors.invalidURL
        }
        
        
        if let queryParams = endPoint.queryParams {
            urlComponents.queryItems = queryParams
        }
        
        guard let urlWithPath = urlComponents.url else {
            var request = URLRequest(url: url)
            request.httpMethod = endPoint.method.rawValue
            request.allHTTPHeaderFields = endPoint.headers
            return request
            
        }
        
        var request = URLRequest(url: urlWithPath)
        request.httpMethod = endPoint.method.rawValue
        if endPoint.method == .post {
            request.httpBody = urlComponents.query?.data(using: .utf8)
        }
        request.allHTTPHeaderFields = endPoint.headers
        
        return request
    }
    
    // MARK: - Get or Request API Call
    func getData(from endPoint: EndPoint) async throws -> APIResponse {
        let request = try await createRquest(from: endPoint)
        let response: NetworkResponseData = try await session.data(for: request)
        if let httpResponse = response.response as? HTTPURLResponse {
            let apiResponse : APIResponse = (response.data, httpResponse.statusCode)
            return apiResponse
        } else {
            return (Data(), 404)
        }
    }
}
