//
//  CertificateHelper.swift
//  Domain
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation

public class CertificateHelper {

    private let keychainRepository: KeychainRepository

    private var appCertificates = [SecCertificate]()

    public init(keychainRepository: KeychainRepository) {
        self.keychainRepository = keychainRepository
    }

    public func importAppCertificates(bundle: Bundle = Bundle.main,
                                      onSuccess: (() -> Void)? = nil,
                                      onFailure: ((_ error: Error) -> Void)? = nil) {
        let certificates = CertificateConstants.getCertificates()

        do {
            try certificates.forEach { certificate in
                let fileUrl = bundle.url(forResource: certificate, withExtension: DomainConstants.FileExtension.certificate)
                if let file = fileUrl {
                    let data = try Data(contentsOf: file)
                    let key = CertificateConstants.prefixCertificate + certificate
                    keychainRepository.save(object: data, key: key, onSuccess: {
                        onSuccess?()
                    }, onFailure: {
                        onFailure?($0)
                    })
                } else {
                    throw GenericDomainError(type: .notFound, description: "Certificate not found")
                }
            }
        } catch {
            Logger.print("❌ Certificates retrieved error: \(error.localizedDescription)")
            onFailure?(error)
        }
    }

    public func removeAllCertificates(onSuccess: (() -> Void)? = nil,
                                      onFailure: ((_ error: Error) -> Void)? = nil) {
        keychainRepository.clear(onSuccess: {
            onSuccess?()
        }, onFailure: {
            onFailure?($0)
        })
    }

    public func getCertificateCredentials(_ challenge: URLAuthenticationChallenge) -> (challengeDisposition: URLSession.AuthChallengeDisposition, urlCredential: URLCredential?) {

        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let serverTrust = challenge.protectionSpace.serverTrust,
               self.validate(serverTrust: serverTrust) {
                return (.useCredential, URLCredential(trust: serverTrust))
            } else {
                return (.cancelAuthenticationChallenge, nil)
            }
        } else {
            return (.performDefaultHandling, nil)
        }
    }

    private func validate(serverTrust: SecTrust) -> Bool {
        var secresult = SecTrustResultType.invalid
        let status = SecTrustEvaluate(serverTrust, &secresult)
        if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, .zero),
           errSecSuccess == status {
            let serverCertificateData = SecCertificateCopyData(serverCertificate)
            let data = CFDataGetBytePtr(serverCertificateData)
            let size = CFDataGetLength(serverCertificateData)
            let serverCert = NSData(bytes: data, length: size)

            if appCertificates.isEmpty {
                appCertificates = getAppCertificates()
            }

            for appCertificate in appCertificates {
                let appCertificateData = SecCertificateCopyData(appCertificate)
                let appData = CFDataGetBytePtr(appCertificateData)
                let appSize = CFDataGetLength(appCertificateData)
                let appCert = NSData(bytes: appData, length: appSize)
                if serverCert.isEqual(to: appCert as Data) {
                    return true
                }
            }
        }
        return false
    }

    private func getAppCertificates() -> [SecCertificate] {
        let coroutineManager = CoroutineManager()
        let certificates = CertificateConstants.getCertificates()
        var secCertificates = [SecCertificate]()

        certificates.forEach { certificate in
            let key = CertificateConstants.prefixCertificate + certificate
            let secCertificate = try? coroutineManager.execute { (consumer: @escaping CoroutineManager.Consumer<SecCertificate?>) in
                self.keychainRepository.get(key: key, onSuccess: { certificate in
                    let secCer = (certificate as! SecCertificate) // swiftlint:disable:this force_cast
                    consumer(secCer)
                }, onFailure: { _ in
                    consumer(nil)
                })
            }
            if let secCertObject = secCertificate {
                secCertificates.append(secCertObject)
            }
        }

        return secCertificates
    }

}
