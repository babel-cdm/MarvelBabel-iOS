//
//  MarvelResponseDataModel.swift
//  Data
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation
import Domain

// MARK: - MarvelResponseDataModel
internal struct MarvelResponseDataModel: Decodable {
    internal let code: Int?
    internal let status, copyright, attributionText, attributionHTML: String?
    internal let etag: String?
    internal let data: ContentDataModel?
}

// MARK: - ContentDataModel
internal struct ContentDataModel: Decodable {
    internal let offset, limit, total, count: Int?
    internal let results: [CharacterDataModel]?
}

extension MarvelResponseDataModel {

    internal init(data: Data) throws {
        self = try JSONDecoder().decode(MarvelResponseDataModel.self, from: data)
    }

    internal func parseToDomainModel() -> CharacterPagedDomainModel {
        let characters = data?.results?.compactMap { $0.parseToDomainModel() }
        return CharacterPagedDomainModel(total: data?.total ?? .zero,
                                         characters: characters ?? [])
    }

}
