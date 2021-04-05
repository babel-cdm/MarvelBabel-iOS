//
//  MockedGetCharacterDetailInteractor.swift
//  DomainTests
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation
@testable import Domain

public class MockedGetCharacterDetailInteractor: GetCharacterDetailInteractor {

    // MARK: - Properties

    public enum MockedGetCharacterDetailInteractorResponse {
        case success(_ param: CharacterDomainModel)
        case failure
    }

    public var response: MockedGetCharacterDetailInteractorResponse = .success(
        CharacterDomainModel(identifier: .zero,
                             thumbnailUrl: "",
                             name: "",
                             description: "",
                             comics: .zero,
                             series: .zero,
                             stories: .zero,
                             wiki: "")
    )

    // MARK: - Functions

    public init() {
        super.init(httpRepository: MockedHttpRepository())
    }

    override public func handle(parameter: CharacterDetailInteractorParameter,
                                onSuccess: @escaping (CharacterDomainModel) -> Void,
                                onFailure: @escaping (Error) -> Void,
                                onProcess: @escaping (()) -> Void) {

        switch response {
        case .success(let param):
            onSuccess(param)
        case .failure:
            onFailure(GenericDomainError(type: .unknown))
        }
    }
}
