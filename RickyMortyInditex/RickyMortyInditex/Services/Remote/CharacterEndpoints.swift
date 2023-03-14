//
//  CharacterEndpoints.swift
//  RickyMortyInditex
//
//  Created by Augusto Cordero Perez on 14/3/23.
//

import Foundation

struct CharacterEndpoint: EndpointRepresentable {

    struct Options {
        let page: Int?
        let keywords: String?
    }

    var pathName = "/character"
    let method: HTTPMethod = .get
    let params: [String : Any]

    init(options: Options) {
        var params: [String: String] = [:]
        if let page = options.page {
            params["page"] = "\(page)"
        }
        if let keywords = options.keywords  {
            params["name"] = keywords
        }
        self.params = params
    }
}


struct CharacterDetailEndpoint: EndpointRepresentable {

    var pathName: String
    let method: HTTPMethod = .get
    let params: [String : Any]

    init(id: Int) {
        pathName =  "/character/\(id)"
        params = [:]
    }
}
