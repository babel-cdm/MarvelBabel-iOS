//
//  CharacterDetailViewModel.swift
//  MarvelBabel
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation
import Domain

public struct CharacterDetailViewModel {

    public let identifier: String
    public let coverUrl: String
    public let name: String
    public let description: String
    public let comicsAmount: String
    public let seriesAmount: String
    public let storiesAmount: String
    public let isWikiButtonHidden: Bool

    public init(_ characterDomainModel: CharacterDomainModel) {
        identifier = String(characterDomainModel.identifier)
        coverUrl = characterDomainModel.thumbnailUrl
        name = characterDomainModel.name
        description = characterDomainModel.description
        comicsAmount = String(characterDomainModel.comics)
        seriesAmount = String(characterDomainModel.series)
        storiesAmount = String(characterDomainModel.stories)
        isWikiButtonHidden = characterDomainModel.wiki.isEmpty
    }

}
