//
//  MarvelRequestDataModel.swift
//  Data
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation
import Domain

internal struct MarvelRequestDataModel: Encodable {

    internal let apikey: String
    internal let timeStamp: String
    internal let hash: String
    internal let offset: Int?
    internal let limit: Int?

    internal enum CodingKeys: String, CodingKey {
        case apikey
        case timeStamp = "ts"
        case hash
        case offset
        case limit
    }

    internal init (pbKey: String, pvKey: String,
                   domainModel: CharacterPagedRequestDomainModel? = nil) {
        self.apikey = pbKey
        self.timeStamp = String(Date().timeIntervalSince1970 * 1000)
        self.hash = EncryptionHelper.md5Hex(timeStamp + pvKey + pbKey)
        self.offset = domainModel?.offset
        self.limit = domainModel?.limit
    }

}
