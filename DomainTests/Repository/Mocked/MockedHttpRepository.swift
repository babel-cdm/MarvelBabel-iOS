//
//  MockedHttpRepository.swift
//  DomainTests
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation
@testable import Domain

public enum MockedHttpRepositoryResponse {
    case success
    case failure
}

public class MockedHttpRepository: HttpRepository {

    // MARK: - Properties

    public var result: MockedHttpRepositoryResponse = .success

    // MARK: - KeychainRepository functions

    public func getCharactersPaged(request: CharacterPagedRequestDomainModel, onSuccess: @escaping (CharacterPagedDomainModel) -> Void, onFailure: @escaping (Error) -> Void) {
        switch result {
        case .success:
            onSuccess(CharacterPagedDomainModel(total: .zero, characters: []))
        case .failure:
            onFailure(GenericDomainError(type: .unknown))
        }
    }

    public func getCharacterDetail(request: CharacterDetailRequestDomainModel, onSuccess: @escaping (CharacterDomainModel) -> Void, onFailure: @escaping (Error) -> Void) {
        switch result {
        case .success:
            onSuccess(CharacterDomainModel(identifier: .zero,
                                           thumbnailUrl: "",
                                           name: "",
                                           description: "",
                                           comics: .zero,
                                           series: .zero,
                                           stories: .zero,
                                           wiki: ""))
        case .failure:
            onFailure(GenericDomainError(type: .unknown))
        }
    }

}
