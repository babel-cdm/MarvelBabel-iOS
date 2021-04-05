//
//  GenericDomainError.swift
//  Domain
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation

public enum GenericDomainErrorType {
    case parseFailed
    case notFound
    case emptyData
    case invalidX509Data
    case invalidUrl
    case unknown
}

public enum GenericDomainErrorDescription: String {
    case parseFailed = "Error parsing JSON"
    case mockNotFound = "Mock file not found"
}

public class GenericDomainError: BaseError<GenericDomainErrorType> {

    public override init(type: GenericDomainErrorType, description: String = "") {
        super.init(type: type, description: description)
    }

}
