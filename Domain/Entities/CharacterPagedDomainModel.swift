//
//  CharacterPagedDomainModel.swift
//  Domain
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation

public struct CharacterPagedDomainModel {

    public let total: Int
    public var characters: [CharacterDomainModel]

    public init(total: Int, characters: [CharacterDomainModel]) {
        self.total = total
        self.characters = characters
    }

}

public struct CharacterDomainModel {

    public let identifier: Int
    public let thumbnailUrl: String
    public let name: String
    public let description: String
    public let comics: Int
    public let series: Int
    public let stories: Int
    public let wiki: String

    public init(identifier: Int, thumbnailUrl: String,
                name: String, description: String,
                comics: Int, series: Int,
                stories: Int, wiki: String) {
        self.identifier = identifier
        self.thumbnailUrl = thumbnailUrl
        self.name = name
        self.description = description
        self.comics = comics
        self.series = series
        self.stories = stories
        self.wiki = wiki
    }

}
