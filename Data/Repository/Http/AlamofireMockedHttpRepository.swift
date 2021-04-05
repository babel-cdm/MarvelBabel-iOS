//
//  AlamofireMockedHttpRepository.swift
//  Data
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation
import Domain

public class AlamofireMockedHttpRepository: HttpRepository {

    // MARK: - Singleton

    private static var repositoryInstance = AlamofireMockedHttpRepository()

    public static func shared() -> HttpRepository {
        return AlamofireMockedHttpRepository.repositoryInstance
    }

    // MARK: - HttpRepository functions

    public func getCharactersPaged(request: CharacterPagedRequestDomainModel,
                                   onSuccess: @escaping (_ characterPaged: CharacterPagedDomainModel) -> Void,
                                   onFailure: @escaping (_ error: Error) -> Void) {

        let page = Int(request.offset / request.limit)
        let resource = "CharactersPage\(page)"

        if let path = Bundle.main.path(forResource: resource, ofType: DomainConstants.FileExtension.json) {
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                let marvelResponseDataModel = try MarvelResponseDataModel(data: data)
                let characterPagedDomainModel = marvelResponseDataModel.parseToDomainModel()
                onSuccess(characterPagedDomainModel)
            } catch {
                onFailure(GenericDomainError(type: .parseFailed,
                                             description: GenericDomainErrorDescription.parseFailed.rawValue))
            }
        } else {
            onFailure(GenericDomainError(type: .notFound,
                                         description: GenericDomainErrorDescription.mockNotFound.rawValue))
        }
    }

    public func getCharacterDetail(request: CharacterDetailRequestDomainModel,
                                   onSuccess: @escaping (_ character: CharacterDomainModel) -> Void,
                                   onFailure: @escaping (_ error: Error) -> Void) {
        
        let resource = "CharacterDetail"

        if let path = Bundle.main.path(forResource: resource, ofType: DomainConstants.FileExtension.json) {
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                let marvelResponseDataModel = try MarvelResponseDataModel(data: data)
                if let characterDomainModel = marvelResponseDataModel.parseToDomainModel()
                    .characters.first {
                    onSuccess(characterDomainModel)
                } else {
                    onFailure(GenericDomainError(type: .emptyData))
                }
            } catch {
                onFailure(GenericDomainError(type: .parseFailed,
                                             description: GenericDomainErrorDescription.parseFailed.rawValue))
            }
        } else {
            onFailure(GenericDomainError(type: .notFound,
                                         description: GenericDomainErrorDescription.mockNotFound.rawValue))
        }
    }

}
