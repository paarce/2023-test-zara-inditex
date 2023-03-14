//
//  CharacterListProvider.swift
//  RickyMortyInditex
//
//  Created by Augusto Cordero Perez on 14/3/23.
//

import Foundation

protocol CharacterListProvider {
    func reload() async throws -> [Character]
    func fetchNextPage() async throws -> [Character]
    func search(keywords: String) async throws -> [Character]
}

class CharacterListProviderImpl: CharacterListProvider {

    private var remoteService: CharacterRemoteService
//    private var localService: CharacterLocalService
    private var page: Int
    private var keywords: String = ""

    init(remoteService: CharacterRemoteService, page: Int = 1) {
        self.remoteService = remoteService
//        self.localService = localService
        self.page = page
    }

    func reload() async throws -> [Character] {
        try await fetch(page: page)
    }

    func fetchNextPage() async throws -> [Character] {
        let currentPage = self.page
        let nextPage = currentPage + 1
        return try await fetch(page: nextPage)
    }

    func search(keywords: String) async throws -> [Character] {
        self.keywords = keywords
        return try await fetch(page: 1)
    }

    private func fetch(page: Int) async throws -> [Character] {
        let response = try await remoteService.fecth(options: .init(page: page, keywords: keywords))
        self.page = page
        return response.results
    }
}
