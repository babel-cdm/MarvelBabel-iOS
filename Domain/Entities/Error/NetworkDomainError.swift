//
//  NetworkDomainError.swift
//  Domain
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation

public enum NetworkDomainErrorType {
    case timeout
    case secureConnection
    case methodNotAllowed
    case missingParameter
    case invalidParameter
    case unknown
}

public class NetworkDomainError: BaseError<NetworkDomainErrorType> {

    public override init(type: NetworkDomainErrorType, description: String = "") {
        super.init(type: type, description: description)
    }

}
