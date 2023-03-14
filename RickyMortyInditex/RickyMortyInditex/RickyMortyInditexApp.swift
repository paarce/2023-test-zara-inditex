//
//  RickyMortyInditexApp.swift
//  RickyMortyInditex
//
//  Created by Augusto Cordero Perez on 14/3/23.
//

import SwiftUI

@main
struct RickyMortyInditexApp: App {
    var body: some Scene {
        WindowGroup {
            CharacterListView(
                presenter: .init(provider: CharacterListProviderImpl(remoteService: CharacterRemoteServiceImpl()))
            )
        }
    }
}
