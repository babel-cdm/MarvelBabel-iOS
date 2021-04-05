//
//  CharacterListViewModel.swift
//  MarvelBabel
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation
import Domain

public struct CharacterListViewModel {

    public let characters: [CharacterCellViewModel]

    public init(_ characterPagedDomainModel: CharacterPagedDomainModel) {
        characters = characterPagedDomainModel.characters.map { CharacterCellViewModel($0) }
    }

}
