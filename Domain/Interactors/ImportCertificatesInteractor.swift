//
//  ImportCertificatesInteractor.swift
//  Domain
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation

public class ImportCertificatesInteractor: BaseInteractor<Void, Void, Void> {

    private let userDefaultsRepository: UserDefaultsRepository
    private let certificateHelper: CertificateHelper
    private let currentVersion: String
    private let currentBuild: String

    private static let versionSeparator: Character = "_"

    public init(userDefaultsRepository: UserDefaultsRepository,
                certificateHelper: CertificateHelper,
                currentVersion: String,
                currentBuild: String) {
        self.userDefaultsRepository = userDefaultsRepository
        self.certificateHelper = certificateHelper
        self.currentVersion = currentVersion
        self.currentBuild = currentBuild
        super.init()
    }

    public override func handle(onSuccess: @escaping () -> Void,
                                onFailure: @escaping (Error) -> Void,
                                onProcess: @escaping (()) -> Void) {

        var storedVersionNumber = ""
        var storedBuildNumber = Int.zero

        userDefaultsRepository
            .get(key: RepositoryConstants.UserDefaults.Key.appVersion,
                 onSuccess: { storedAppVersionData in

                    if let storedAppVersionString = storedAppVersionData as? String {
                        let storedAppVersionStringSplitted = storedAppVersionString.split(separator: ImportCertificatesInteractor.versionSeparator)
                        storedVersionNumber = String(storedAppVersionStringSplitted.first ?? "")
                        storedBuildNumber = Int(storedAppVersionStringSplitted.last ?? "") ?? .zero
                    }

                    self.checkAppVersion(storedVersionNumber: storedVersionNumber,
                                         storedBuildNumber: storedBuildNumber,
                                         onSuccess: onSuccess, onFailure: onFailure)
                 },
                 onFailure: { error in
                    if let genericError = error as? GenericDomainError,
                       genericError.type == .notFound {
                        self.checkAppVersion(storedVersionNumber: storedVersionNumber,
                                             storedBuildNumber: storedBuildNumber,
                                             onSuccess: onSuccess, onFailure: onFailure)
                    } else {
                        onFailure(error)
                    }
                 })
    }

    private func checkAppVersion(storedVersionNumber: String,
                                 storedBuildNumber: Int,
                                 onSuccess: @escaping () -> Void,
                                 onFailure: @escaping (Error) -> Void) {

        let currentVersionNumber = self.currentVersion
        let currentBuildNumber = Int(self.currentBuild) ?? .zero

        var storedVersionDeprecated = false
        let storedVersionNumberSplitted = storedVersionNumber.split(separator: ".")
        let currentVersionNumberSplitted = currentVersionNumber.split(separator: ".")

        for (index, currentVersionSection) in currentVersionNumberSplitted.enumerated() {
            if index < storedVersionNumberSplitted.count {
                let currentVersionSectionNumber = Int(currentVersionSection) ?? .zero
                let storedVersionSectionNumber = Int(storedVersionNumberSplitted[index]) ?? .zero

                if storedVersionSectionNumber < currentVersionSectionNumber {
                    storedVersionDeprecated = true
                    break
                }
            } else {
                storedVersionDeprecated = true
                break
            }
        }

        if storedVersionDeprecated || (!storedVersionDeprecated && storedBuildNumber < currentBuildNumber) {
            self.certificateHelper.removeAllCertificates()
            self.certificateHelper.importAppCertificates(onSuccess: {

                let currentAppVersionString = "\(currentVersionNumber)" +
                    "\(ImportCertificatesInteractor.versionSeparator)" +
                    "\(currentBuildNumber)"

                self.userDefaultsRepository.save(object: currentAppVersionString,
                                                 key: RepositoryConstants.UserDefaults.Key.appVersion,
                                                 onSuccess: onSuccess, onFailure: onFailure)
            }, onFailure: onFailure)
        } else {
            onSuccess()
        }
    }

}
