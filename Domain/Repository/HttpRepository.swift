//
//  HttpRepository.swift
//  Domain
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation

public protocol HttpRepository {
    func getCharactersPaged(request: CharacterPagedRequestDomainModel,
                            onSuccess: @escaping (_ characterPaged: CharacterPagedDomainModel) -> Void,
                            onFailure: @escaping (_ error: Error) -> Void)
    func getCharacterDetail(request: CharacterDetailRequestDomainModel,
                            onSuccess: @escaping (_ character: CharacterDomainModel) -> Void,
                            onFailure: @escaping (_ error: Error) -> Void)
}
