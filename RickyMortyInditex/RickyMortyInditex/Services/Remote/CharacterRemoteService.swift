//
//  CharacterRemoteService.swift
//  RickyMortyInditex
//
//  Created by Augusto Cordero Perez on 14/3/23.
//

import Foundation

import Foundation

protocol CharacterRemoteService {
    func fecth(
        options: CharacterEndpoint.Options
    ) async throws -> CharacterList

    func find(
        id: Int
    ) async throws -> Character
}

class CharacterRemoteServiceImpl: CharacterRemoteService {

    private let client: NetworkClient

    init(client: NetworkClient = URLSessionNetworkClient()) {
        self.client = client
    }

    func fecth(
        options: CharacterEndpoint.Options
    ) async throws -> CharacterList {
        let endpoint = CharacterEndpoint(options: options)
        return try await client.perform(for: APIRequest.urlRequest(by: endpoint))
    }

    func find(id: Int) async throws -> Character {
        let endpoint = CharacterDetailEndpoint(id: id)
        let list: CharacterList = try await client.perform(for: APIRequest.urlRequest(by: endpoint))
        if let Character = list.results.first {
            return Character
        } else {
            throw APIError.serverError
        }
    }
}
