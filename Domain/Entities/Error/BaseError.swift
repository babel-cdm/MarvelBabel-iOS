//
//  BaseError.swift
//  Domain
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation

open class BaseError<ErrorType>: LocalizedError {

    public let type: ErrorType
    public let description: String
    public var errorDescription: String? {
        return description
    }

    public init(type: ErrorType, description: String) {
        self.type = type
        self.description = description
    }

}
