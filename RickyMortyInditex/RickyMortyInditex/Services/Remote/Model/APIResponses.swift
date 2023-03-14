//
//  APIResponses.swift
//  RickyMortyInditex
//
//  Created by Augusto Cordero Perez on 14/3/23.
//

import Foundation

struct ResponseList<T>: Decodable where T: Decodable {
    let info: Info
    let results: [T]
}

struct Info: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

extension Info {
    var nextPageIndex: Int? {
        guard let strNextPage = self.next, let url = URLComponents(string: strNextPage),
            let nextPageVal = url.queryItems?.first(where: { $0.name == strNextPage })?.value
        else { return nil }
        return Int(nextPageVal)
    }
}
