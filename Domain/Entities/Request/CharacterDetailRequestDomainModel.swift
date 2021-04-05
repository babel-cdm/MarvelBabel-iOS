//
//  CharacterDetailRequestDomainModel.swift
//  Domain
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation

public struct CharacterDetailRequestDomainModel {

    public let identifier: String

    public init(identifier: Int) {
        self.identifier = String(identifier)
    }

}
