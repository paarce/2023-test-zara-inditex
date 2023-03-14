//
//  EndpointRepresentable.swift
//  RickyMortyInditex
//
//  Created by Augusto Cordero Perez on 14/3/23.
//

import Foundation

enum HTTPMethod: String {
    case put = "PUT"
    case post = "POST"
    case get = "GET"
    case delete = "DELETE"
}

protocol EndpointRepresentable {
    var pathName: String { get }
    var method: HTTPMethod { get }
    var params: [String: Any] { get }
    var headers: [String: String] { get }
}

extension EndpointRepresentable {
    var headers: [String: String] { [:] }
}
