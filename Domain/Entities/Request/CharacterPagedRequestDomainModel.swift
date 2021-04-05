//
//  CharacterPagedRequestDomainModel.swift
//  Domain
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation

public struct CharacterPagedRequestDomainModel {

    public let offset: Int
    public let limit: Int

    public init(offset: Int, limit: Int) {
        self.offset = offset
        self.limit = limit
    }

}
