//
//  CharacterDetailView.swift
//  RickyMortyInditex
//
//  Created by Augusto Cordero Perez on 14/3/23.
//

import SwiftUI

struct CharacterDetailView: View {

    var presenter: CharacterDetailPresenter

    @ObservedObject private var content = CharacterDetailContent()
    @State private var titleRect: CGRect = .zero
    @State private var headerImageRect: CGRect = .zero
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading, spacing: Constants.spacing / 2) {
                    Text("\(presenter.character.status.rawValue) • \(presenter.character.species.rawValue)")
                        .foregroundColor(.gray)

                    Text(presenter.character.name)
                        .background(ComponentSizeColector(rect: self.$titleRect))
                }
                .padding(Constants.spacing)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .offset(y: Constants.imageHeight + Constants.spacing)
            .background(ComponentSizeColector(rect: $content.frame))

            GeometryReader { geometry in
        
                ZStack(alignment: .bottom) {

                    RemoteImage(
                        url: presenter.character.image,
                        placeholder: { Image(systemName: "photo.fill")}
                    )
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: presenter.headerImageHeight(geometry))
                        .clipped()
                        .background(ComponentSizeColector(rect: self.$headerImageRect))

                    Text(presenter.character.name)
                        .foregroundColor(.white)
                        .offset(x: 0, y: presenter.titleOffset(topViewMidY: titleRect.midY, imageRectY: headerImageRect.maxY))
                }
                .clipped()
                .offset(x: 0, y: presenter.headerImageOffset(geometry, imageHeight: Constants.imageHeight))
            }
                .frame(height: Constants.imageHeight)
                .offset(x: 0, y: -(content.startingRect?.maxY ?? UIScreen.main.bounds.height))
            
        }
        .edgesIgnoringSafeArea(.all)
    }

    enum Constants {
        static let spacing: CGFloat = 16
        static let imageHeight: CGFloat = 200
    }
}

struct CharacterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterDetailView(presenter: .init(character: .init(
            id: 1,
            name: "Rick Sanchez",
            status: .alive,
            species: .human,
            type: "",
            gender: .male,
            origin: .init(name: "Earth (C-137)", url: "https://rickandmortyapi.com/api/location/1"),
            location: .init(name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"),
            url: "https://rickandmortyapi.com/api/character/1",
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"
            )
        ))
    }
}

struct RectanglePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct ComponentSizeColector: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { geometry in
            AnyView(Color.clear)
                .preference(
                    key: RectanglePreferenceKey.self,
                    value: geometry.frame(in: .global)
                )
        }.onPreferenceChange(RectanglePreferenceKey.self) { (value) in
            self.rect = value
        }
    }
}
