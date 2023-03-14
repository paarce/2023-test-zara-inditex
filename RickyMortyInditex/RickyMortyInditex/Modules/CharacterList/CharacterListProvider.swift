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
}

class CharacterListProviderImpl: CharacterListProvider {

    private var remoteService: CharacterRemoteService
//    private var localService: CharacterLocalService
    private var page: Int?
    private var keywords: String = ""

    init(remoteService: CharacterRemoteService) {
        self.remoteService = remoteService
//        self.localService = localService
    }

    func reload() async throws -> [Character] {
        try await fetch(page: page ?? 0)
    }

    func fetchNextPage() async throws -> [Character] {
        let currentPage = self.page ?? -1
        let nextPage = currentPage + 1
        return try await fetch(page: nextPage)
    }


    func fetch(page: Int) async throws -> [Character] {
        let response = try await remoteService.fecth(options: .init(page: page, keywords: keywords))
        self.page = response.info.nextPageIndex
        return response.results
    }
}
