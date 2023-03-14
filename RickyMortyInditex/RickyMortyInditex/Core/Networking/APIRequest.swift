//
//  APIRequest.swift
//  RickyMortyInditex
//
//  Created by Augusto Cordero Perez on 14/3/23.
//

import Foundation


struct Environment {

    var baseUrlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "rickandmortyapi.com"
        urlComponents.path = "/api"
        return urlComponents
    }
}

struct APIRequest {

    static func urlRequest(
        by endpoint: EndpointRepresentable
    ) throws ->  URLRequest {
        let environment = Environment()
        var urlComponents = environment.baseUrlComponents
        urlComponents.path = urlComponents.path.appending(endpoint.pathName)
        urlComponents.queryItems = []
        var body: Data?

        switch endpoint.method {
        case .post:
            guard let bodyContent = try? JSONSerialization.data(withJSONObject: endpoint.params)
            else { throw APIError.badRequest }
            body = bodyContent
        case .get:
            guard let params = endpoint.params as? [String: String]
            else { throw APIError.badRequest }
            urlComponents.queryItems?
                .append(contentsOf: params.map({ URLQueryItem(name: $0, value: $1)}))
        default:
            break
        }

        guard let baseURL = urlComponents.url else { throw APIError.badRequest }
        var urlRequest =  URLRequest(url: baseURL)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.httpBody = body

        endpoint.headers.forEach { (key, value) in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        return urlRequest
    }
}
