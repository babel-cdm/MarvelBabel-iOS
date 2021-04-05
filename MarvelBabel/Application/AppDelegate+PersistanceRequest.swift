//
//  AppDelegate+PersistanceRequest.swift
//  MarvelBabel
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation

extension AppDelegate {

    // MARK: - Certificates

    internal func importCertificates() {
        importCertificatesInteractor
            .execute()
            .dispose()
    }
}
