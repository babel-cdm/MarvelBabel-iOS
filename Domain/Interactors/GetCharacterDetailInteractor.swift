//
//  GetCharacterDetailInteractor.swift
//  Domain
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation

public struct CharacterDetailInteractorParameter {

    public let identifier: Int

    public init(identifier: Int) {
        self.identifier = identifier
    }
}

public class GetCharacterDetailInteractor: BaseInteractor<CharacterDetailInteractorParameter,
                                                          CharacterDomainModel,
                                                          Void> {

    private let httpRepository: HttpRepository

    public init(httpRepository: HttpRepository) {
        self.httpRepository = httpRepository
        super.init()
    }

    override public func handle(parameter: CharacterDetailInteractorParameter,
                                onSuccess: @escaping (CharacterDomainModel) -> Void,
                                onFailure: @escaping (Error) -> Void,
                                onProcess: @escaping (()) -> Void) {
        let request = CharacterDetailRequestDomainModel(identifier: parameter.identifier)

        httpRepository.getCharacterDetail(request: request,
                                          onSuccess: onSuccess,
                                          onFailure: onFailure)
    }
}
