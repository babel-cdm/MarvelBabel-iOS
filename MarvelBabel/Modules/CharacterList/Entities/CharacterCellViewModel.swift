//
//  CharacterCellViewModel.swift
//  MarvelBabel
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation
import Domain

public struct CharacterCellViewModel {

    private static let maxNumberWithoutZero = 9

    public let coverUrl: String
    public let title: String
    public let description: String

    public init(_ characterDomainModel: CharacterDomainModel) {
        let identifier = characterDomainModel.identifier <= CharacterCellViewModel.maxNumberWithoutZero
            ? "0\(characterDomainModel.identifier)"
            : "\(characterDomainModel.identifier)"

        self.coverUrl = characterDomainModel.thumbnailUrl
        self.title = characterDomainModel.name.capitalized
        self.description = String(format: "CharacterList.Cell.Description".localized, identifier)
    }

}
