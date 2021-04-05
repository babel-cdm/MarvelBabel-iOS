//
//  EncryptionDomainError.swift
//  Domain
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation

public enum EncryptionDomainErrorType {
    case keyError
    case ivError
    case cryptorError
}

public class EncryptionDomainError: BaseError<EncryptionDomainErrorType> {

    public override init(type: EncryptionDomainErrorType, description: String = "") {
        super.init(type: type, description: description)
    }

}
