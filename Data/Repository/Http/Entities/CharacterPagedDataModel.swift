//
//  CharacterPagedDataModel.swift
//  Data
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation
import Domain

// MARK: - CharacterDataModel
internal struct CharacterDataModel: Decodable {
    internal let id: Int?
    internal let name, description: String?
    internal let modified: String?
    internal let thumbnail: ThumbnailDataModel?
    internal let resourceURI: String?
    internal let comics, series, stories, events: ResourceDataModel?
    internal let urls: [UrlElementDataModel]?
}

// MARK: - Thumbnail
internal struct ThumbnailDataModel: Decodable {
    internal let path: String?
    internal let thumbnailExtension: String?

    internal enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

// MARK: - ResourceDataModel
internal struct ResourceDataModel: Decodable {
    internal let available: Int?
    internal let collectionURI: String?
    internal let items: [ItemDataModel]?
    internal let returned: Int?
}

// MARK: - ItemDataModel
internal struct ItemDataModel: Decodable {
    internal let resourceURI: String?
    internal let name: String?
}

// MARK: - UrlElementDataModel
internal struct UrlElementDataModel: Decodable {
    internal let type: UrlDataType?
    internal let url: String?
}

internal enum UrlDataType: String, Decodable {
    case comiclink
    case detail
    case wiki
}

extension CharacterDataModel {

    internal func parseToDomainModel() -> CharacterDomainModel {
        var thumbnailUrl = (thumbnail?.path ?? "")
            .replacingOccurrences(of: DomainConstants.ProtocolHost.http,
                                  with: DomainConstants.ProtocolHost.https)
        if let thumbnailExtension = thumbnail?.thumbnailExtension {
            thumbnailUrl += ".\(thumbnailExtension)"
        }

        let wikiUrl = urls?.first(where: { $0.type == .wiki }).map { $0.url ?? "" }

        return CharacterDomainModel(identifier: id ?? .zero,
                                    thumbnailUrl: thumbnailUrl,
                                    name: name ?? "",
                                    description: description ?? "",
                                    comics: comics?.available ?? .zero,
                                    series: series?.available ?? .zero,
                                    stories: stories?.available ?? .zero,
                                    wiki: wikiUrl ?? "")
    }

}
