//
//  CharacterListView.swift
//  RickyMortyInditex
//
//  Created by Augusto Cordero Perez on 14/3/23.
//

import SwiftUI

struct CharacterListView: View {

    @State private var searchText = ""
    @ObservedObject var presenter: CharacterListPresenter
    private let columns = [
        SwiftUI.GridItem(.flexible()),
        SwiftUI.GridItem(.flexible())
    ]

    var body: some View {

        VStack {
            if !presenter.characters.isEmpty {
                gridView
            }
            switch presenter.state {
            case .loading:
                Text("Loading...")
            case .fail(let error):
                Text("Error: \(error.localizedDescription)")
            default:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear(perform: presenter.initLoad)
        .searchable(text: $searchText)
        .onChange(of: searchText) { keywords in
            self.presenter.search(change: keywords)
        }
    }

    private var gridView: some View {
        GeometryReader { proxy in
            ScrollView {
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(presenter.characters) { item in
                        gridCell(item, width: proxy.size.width / 2)
                    }
                }
            }
        }
    }

    private func gridCell(_ character: Character, width: CGFloat) -> some View {
        NavigationLink(
            destination: EmptyView(),
            label: {
                CharacterItemView(character: character, width: width)
                    .onAppear(perform: { presenter.loadNextPageIfNeed(character) })
            }
        )
    }
}

struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView(
            presenter: .init(provider: CharacterListProviderImpl(remoteService: CharacterRemoteServiceImpl()))
        )
    }
}

struct CharacterItemView: View {
    let character: Character
    let width: CGFloat
    private let height: CGFloat = 200

    var body: some View {

        ZStack(alignment: .top) {

            RemoteImage(
                url: character.image,
                placeholder: { Image(systemName: "photo.fill")}
            )
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: width, maxHeight: height)
                .clipped()
                .opacity(0.4)

            Text(character.name)
                .padding(10)
                .font(Font.system(size: 15, weight: .black))

        }
        .frame(width: width, height: height)
    }
}
