//
//  AlamofireSessionDelegate.swift
//  Data
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation
import Domain
import Alamofire

open class AlamofireSessionDelegate: SessionDelegate {

    // MARK: - Properties

    private let certificateHelper: CertificateHelper

    // MARK: - Initializer

    public init(certificateHelper: CertificateHelper) {
        self.certificateHelper = certificateHelper
    }

    // MARK: - SessionDelegate functions

    open override func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let certificateCredentials = certificateHelper.getCertificateCredentials(challenge)
        completionHandler(certificateCredentials.challengeDisposition, certificateCredentials.urlCredential)
    }

}
