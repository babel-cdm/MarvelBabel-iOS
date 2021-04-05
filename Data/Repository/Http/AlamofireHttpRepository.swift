//
//  AlamofireHttpRepository.swift
//  Data
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation
import Domain
import Alamofire

public class AlamofireHttpRepository: HttpRepository {

    // MARK: - Properties

    private static let timeout: TimeInterval = 15

    // MARK: - Singleton

    private static var repositoryInstance: AlamofireHttpRepository?

    public static func shared(protocolHost: String, host: String,
                              marvelPBKey: String, marvelPVKey: String,
                              certificateHelper: CertificateHelper) -> HttpRepository {

        if let repositoryInstance = AlamofireHttpRepository.repositoryInstance {
            return repositoryInstance
        } else {
            AlamofireHttpRepository.repositoryInstance = AlamofireHttpRepository(protocolHost: protocolHost,
                                                                                 host: host,
                                                                                 marvelPBKey: marvelPBKey,
                                                                                 marvelPVKey: marvelPVKey,
                                                                                 certificateHelper: certificateHelper)
            return AlamofireHttpRepository.repositoryInstance!
        }
    }

    internal init(protocolHost: String, host: String,
                  marvelPBKey: String, marvelPVKey: String,
                  certificateHelper: CertificateHelper) {
        self.baseUrl = "\(protocolHost)\(host)"
        self.marvelPBKey = marvelPBKey
        self.marvelPVKey = marvelPVKey

        let sessionDelegate = AlamofireSessionDelegate(certificateHelper: certificateHelper)
        self.session = AlamofireHttpRepository.getAlamofireSession(host: host,
                                                                   sessionDelegate: sessionDelegate)
    }

    // MARK: - Properties

    private let baseUrl: String
    private let marvelPBKey: String
    private let marvelPVKey: String
    private let session: Session

    // MARK: - HttpRepository functions

    public func getCharactersPaged(request: CharacterPagedRequestDomainModel,
                                   onSuccess: @escaping (_ characterPaged: CharacterPagedDomainModel) -> Void,
                                   onFailure: @escaping (_ error: Error) -> Void) {

        let url = baseUrl + RepositoryConstants.Http.Endpoint.characters

        let parameters = MarvelRequestDataModel(pbKey: marvelPBKey, pvKey: marvelPVKey,
                                                domainModel: request)

        session.request(url,
                        method: .get,
                        parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success:
                    do {
                        if let data = response.data {
                            let marvelResponseDataModel = try MarvelResponseDataModel(data: data)
                            let characterPagedDomainModel = marvelResponseDataModel.parseToDomainModel()
                            onSuccess(characterPagedDomainModel)
                        } else {
                            onFailure(GenericDomainError(type: .emptyData))
                        }
                    } catch {
                        onFailure(GenericDomainError(type: .parseFailed, description: error.localizedDescription))
                    }
                case let .failure(error):
                    onFailure(AlamofireHttpRepository.getError(error))
                }
            }
    }

    public func getCharacterDetail(request: CharacterDetailRequestDomainModel,
                                   onSuccess: @escaping (_ character: CharacterDomainModel) -> Void,
                                   onFailure: @escaping (_ error: Error) -> Void) {

        let url = baseUrl + String(format: RepositoryConstants.Http.Endpoint.characterDetail,
                                   request.identifier)

        let parameters = MarvelRequestDataModel(pbKey: marvelPBKey, pvKey: marvelPVKey)

        session.request(url,
                        method: .get,
                        parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success:
                    do {
                        if let data = response.data {
                            let marvelResponseDataModel = try MarvelResponseDataModel(data: data)
                            if let characterDomainModel = marvelResponseDataModel.parseToDomainModel()
                                .characters.first {
                                onSuccess(characterDomainModel)
                            } else {
                                onFailure(GenericDomainError(type: .emptyData))
                            }
                        } else {
                            onFailure(GenericDomainError(type: .emptyData))
                        }
                    } catch {
                        onFailure(GenericDomainError(type: .parseFailed, description: error.localizedDescription))
                    }
                case let .failure(error):
                    onFailure(AlamofireHttpRepository.getError(error))
                }
            }
    }

    // MARK: - Private functions

    private static func getAlamofireSession(host: String, sessionDelegate: AlamofireSessionDelegate) -> Alamofire.Session {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = AlamofireHttpRepository.timeout

        return Alamofire.Session(configuration: configuration, delegate: sessionDelegate)
    }

    private static func getError(_ error: Error) -> Error {
        Logger.print("-- ⚠️ Http Error: \(error._code) - \(error.localizedDescription) --")
        switch error._code {
        case NSURLErrorTimedOut:
            return NetworkDomainError(type: .timeout, description: error.localizedDescription)
        case NSURLErrorAppTransportSecurityRequiresSecureConnection:
            return NetworkDomainError(type: .secureConnection, description: error.localizedDescription)
        default:
            var networkError = NetworkDomainError(type: .unknown,
                                                  description: "\(error._code) - \(error.localizedDescription)")
            if let afError = error as? AFError, let responseCode = afError.responseCode {
                switch responseCode {
                case 401:
                    networkError = NetworkDomainError(type: .invalidParameter,
                                                      description: afError.localizedDescription)
                case 405:
                    networkError = NetworkDomainError(type: .methodNotAllowed,
                                                      description: afError.localizedDescription)
                case 409:
                    networkError = NetworkDomainError(type: .missingParameter,
                                                      description: afError.localizedDescription)
                default:
                    networkError = NetworkDomainError(type: .unknown,
                                                      description: "\(responseCode) - \(afError.localizedDescription)")
                }
            }

            return networkError
        }
    }

}
