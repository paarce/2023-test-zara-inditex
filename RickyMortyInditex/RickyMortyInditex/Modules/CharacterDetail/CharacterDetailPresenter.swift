//
//  CharacterDetailPresenter.swift
//  RickyMortyInditex
//
//  Created by Augusto Cordero Perez on 14/3/23.
//

import Foundation
import SwiftUI

class CharacterDetailContent: ObservableObject {
    var startingRect: CGRect?

    @Published var frame: CGRect = .zero {
        willSet {
            if startingRect == nil {
                startingRect = newValue
            }
        }
    }
}

class CharacterDetailPresenter {

    var character: Character

    init(character: Character) {
        self.character = character
    }

    enum Constants {
        static let minYValue: CGFloat = 50.0
        static let finalOffset: CGFloat = -30.0
        static let topSafeAreaPadding: CGFloat = 20
        static let collapsedImageHeight: CGFloat = 75
    }
}

extension CharacterDetailPresenter {

    func headerImageOffset(_ geometry: GeometryProxy, imageHeight: CGFloat) -> CGFloat {
        let offset = geometry.frame(in: .global).minY
        let sizeOffScreen = imageHeight - Constants.collapsedImageHeight

        if offset < -sizeOffScreen {
            let imageOffset = abs(min(-sizeOffScreen, offset))
            return imageOffset - sizeOffScreen
        }

        if offset > 0 {
            return -offset
        }

        return 0
    }

    func headerImageHeight(_ geometry: GeometryProxy) -> CGFloat {
        let offset = geometry.frame(in: .global).minY
        var imageHeight = geometry.size.height

        if offset > 0 {
            imageHeight += offset
        }

        return imageHeight
    }

    func titleOffset(topViewMidY: CGFloat, imageRectY: CGFloat) -> CGFloat {
        let currentYPos = topViewMidY
        if currentYPos < imageRectY {
            let maxYValue: CGFloat = Constants.collapsedImageHeight
            let currentYValue = currentYPos

            let percentage = max(-1, (currentYValue - maxYValue) / (maxYValue - Constants.minYValue))

            return Constants.topSafeAreaPadding - (percentage * Constants.finalOffset)
        }

        return .infinity
    }
}
