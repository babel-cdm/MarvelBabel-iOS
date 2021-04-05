//
//  GetCharactersPagedInteractor.swift
//  Domain
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation

public struct CharacterPagedInteractorParameter {

    public let offset: Int
    public let limit: Int

    public init(offset: Int, limit: Int) {
        self.offset = offset
        self.limit = limit
    }
}

public class GetCharactersPagedInteractor: BaseInteractor<CharacterPagedInteractorParameter,
                                                          CharacterPagedDomainModel,
                                                          Void> {

    private let httpRepository: HttpRepository

    public init(httpRepository: HttpRepository) {
        self.httpRepository = httpRepository
        super.init()
    }

    override public func handle(parameter: CharacterPagedInteractorParameter,
                                onSuccess: @escaping (CharacterPagedDomainModel) -> Void,
                                onFailure: @escaping (Error) -> Void,
                                onProcess: @escaping (()) -> Void) {
        let request = CharacterPagedRequestDomainModel(offset: parameter.offset,
                                                     limit: parameter.limit)

        httpRepository.getCharactersPaged(request: request,
                                          onSuccess: onSuccess,
                                          onFailure: onFailure)
    }
}
