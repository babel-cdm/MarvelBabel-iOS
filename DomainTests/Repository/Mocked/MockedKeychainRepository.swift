//
//  MockedKeychainRepository.swift
//  DomainTests
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation
@testable import Domain

public enum MockedKeychainRepositoryResponse {
    case success
    case failure
}

public class MockedKeychainRepository: KeychainRepository {

    // MARK: - Properties

    public var result: MockedKeychainRepositoryResponse = .success

    // MARK: - KeychainRepository functions

    public func save(object: Any, key: String, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        switch result {
        case .success:
            onSuccess()
        case .failure:
            onFailure(GenericDomainError(type: .unknown))
        }
    }

    public func get(key: String, onSuccess: @escaping (Any?) -> Void, onFailure: @escaping (Error) -> Void) {
        switch result {
        case .success:
            onSuccess("")
        case .failure:
            onFailure(GenericDomainError(type: .unknown))
        }
    }

    public func delete(key: String, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        switch result {
        case .success:
            onSuccess()
        case .failure:
            onFailure(GenericDomainError(type: .unknown))
        }
    }

    public func clear(onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        switch result {
        case .success:
            onSuccess()
        case .failure:
            onFailure(GenericDomainError(type: .unknown))
        }
    }
    
}
