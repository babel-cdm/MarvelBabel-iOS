//
//  DependencyInjector.swift
//  MarvelBabel
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation
import Domain
import Data

internal final class DependencyInjector {

    internal static let shared = DependencyInjector()

    // MARK: - Repositories

    private func getUserDefaultsRepository() -> UserDefaultsRepository {
        return IosUserDefaultsRepository.shared(userDefaultsKey: RepositoryConstants.UserDefaults.keyAESUserDefaults)
    }

    private func getKeyChainCertificateRepository() -> KeychainRepository {
        return IosKeychainCertificateRepository.shared()
    }

    private func getHttpRepository() -> HttpRepository {
        #if MOCK
        return AlamofireMockedHttpRepository.shared()
        #else
        return AlamofireHttpRepository.shared(protocolHost: EnvironmentConstants.protocolHost,
                                              host: EnvironmentConstants.restHost,
                                              marvelPBKey: EnvironmentConstants.marvelPBKey,
                                              marvelPVKey: EnvironmentConstants.marvelPVKey,
                                              certificateHelper: getCertificateHelper())
        #endif
    }

    // MARK: - Helpers

    private func getCertificateHelper() -> CertificateHelper {
        return CertificateHelper(keychainRepository: getKeyChainCertificateRepository())
    }

    // MARK: - Interactors

    internal func importCertificatesInteractor() -> ImportCertificatesInteractor {
        return ImportCertificatesInteractor(userDefaultsRepository: getUserDefaultsRepository(),
                                            certificateHelper: getCertificateHelper(),
                                            currentVersion: Application.getAppVersion(),
                                            currentBuild: Application.getBuildNumber())
    }

    private func getCharactersPagedInteractor() -> GetCharactersPagedInteractor {
        return GetCharactersPagedInteractor(httpRepository: getHttpRepository())
    }

    private func getCharacterDetailInteractor() -> GetCharacterDetailInteractor {
        return GetCharacterDetailInteractor(httpRepository: getHttpRepository())
    }

    // MARK: - Presenters

    internal func getCharacterListPresenter(view: CharacterListViewProtocol,
                                            router: MainWireframeProtocol) -> CharacterListPresenterProtocol {
        return CharacterListPresenter(view: view, router: router,
                                      getCharactersPagedInteractor: getCharactersPagedInteractor())
    }

    internal func getCharacterDetailPresenter(view: CharacterDetailViewProtocol,
                                              router: MainWireframeProtocol,
                                              characterDomainModel: CharacterDomainModel) -> CharacterDetailPresenterProtocol {
        return CharacterDetailPresenter(view: view, router: router,
                                        characterDomainModel: characterDomainModel,
                                        getCharacterDetailInteractor: getCharacterDetailInteractor())
    }

}
