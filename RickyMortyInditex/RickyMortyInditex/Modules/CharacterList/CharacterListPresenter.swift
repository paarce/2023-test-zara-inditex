//
//  CharacterListPresenter.swift
//  RickyMortyInditex
//
//  Created by Augusto Cordero Perez on 14/3/23.
//

import Foundation

enum CharacterListViewState {
    case loading
    case fail(Error)
    case idle
}

class CharacterListPresenter: ObservableObject {

    private var provider: CharacterListProvider
    @Published var state: CharacterListViewState
    @Published var characters: [Character] = []

    private var searchTask: DispatchWorkItem?

    init(state: CharacterListViewState = .idle, provider: CharacterListProvider) {
        self.state = state
        self.provider = provider
    }

    func initLoad() {
        guard characters.isEmpty else { return }
        self.reload()
    }

    func reload() {
        guard case .idle = state else { return }
        state = .loading
        Task {
            do {
                update(content: try await provider.reload())
            } catch {
                self.state = .fail(error)
            }
        }
    }

    func loadNextPageIfNeed(_ lastItemShown: Character) {
        guard case .idle = state, shouldFetchNextPage(lastItemShown) else { return }
        state = .loading
        Task {
            do {
                update(content: try await provider.fetchNextPage())
            } catch {
                update(state: .fail(error))
            }
        }
    }

    func search(change keywords: String) {

        searchTask?.cancel()
        searchTask = nil

        let task = DispatchWorkItem { [weak self] in
            self?.search(keywords: keywords)
        }

        searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)
    }

    private func search(keywords: String) {
        Task {
            do {
                update(content: try await self.provider.search(keywords: keywords) )
            } catch {
                update(state: .fail(error))
            }
        }
    }
}

extension CharacterListPresenter {

    private func shouldFetchNextPage(_ lastItemShown: Character) -> Bool {
        let divider = characters.count - Constants.offsetToLoadMore
        guard let index = characters.firstIndex(of: lastItemShown), index > divider else {
            return false
        }
        return true
    }

    private func update(content: [Character]? = nil, state: CharacterListViewState = .idle) {
        DispatchQueue.main.async {
            if let content {
                self.characters.append(contentsOf: content)
            }
            self.state = state
        }
    }

    private enum Constants {
        static let offsetToLoadMore = 5
    }
}

extension Character: Identifiable, Equatable {
    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id
    }
}
