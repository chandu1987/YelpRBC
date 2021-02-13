//
//  EndPoint.swift
//  YelpRBC
//
//  Created by Chandra Sekhar Ravi on 10/02/21.
//

import Foundation

protocol Endpoint {
    associatedtype DataType: Codable
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var decoder: JSONDecoder { get }
    func makeRequest(baseURL: URL) -> URLRequest
}

extension Endpoint {
    var decoder: JSONDecoder { JSONDecoder() }
    
    func makeRequest(baseURL: URL) -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components \(self)")
        }
                
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        
        guard let url = components.url else {
            fatalError("Could not get url from \(components)")
        }
        
        var request = URLRequest(url: url)
        request.setValue(Constants.APIKeys.kYelpAPIKey, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        return URLRequest(url: url)
    }
}

