//
//  MockedUserDefaultsRepository.swift
//  DataTests
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation
@testable import Domain

public enum MockedUserDefaultsRepositoryResponse {
    case success(_ param: Any?)
    case failure
}

public class MockedUserDefaultsRepository: UserDefaultsRepository {

    // MARK: - Properties

    public var result: MockedUserDefaultsRepositoryResponse = .success(nil)

    // MARK: - UserDefaultsRepository functions

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
        case .success(let param):
            onSuccess(param)
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

}
