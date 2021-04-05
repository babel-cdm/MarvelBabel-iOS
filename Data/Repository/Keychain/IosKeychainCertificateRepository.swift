//
//  IosKeychainCertificateRepository.swift
//  Data
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation
import Domain

public final class IosKeychainCertificateRepository: BaseKeychainRepository, KeychainRepository {

    // MARK: - Singleton

    private static var repositoryInstance = IosKeychainCertificateRepository()

    public static func shared() -> KeychainRepository {
        return IosKeychainCertificateRepository.repositoryInstance
    }

    // MARK: - KeychainRepository functions

    public func save(object: Any,
                     key: String,
                     onSuccess: @escaping () -> Void,
                     onFailure: @escaping (_ error: Error) -> Void) {

        Logger.print("ℹ️ℹ️ Adding certificate to keychain with label \(key)")

        guard let certificate = object as? Data, let certificateRef = SecCertificateCreateWithData(kCFAllocatorDefault, certificate as CFData) else {
            Logger.print("❌❌ Could not create certificate, data was not valid DER encoded X509 cert")
            onFailure(GenericDomainError(type: .invalidX509Data))
            return
        }

        let query: [NSString: Any] = [
            kSecClass: kSecClassCertificate,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
            kSecAttrLabel: key,
            kSecValueRef: certificateRef,
            kSecReturnAttributes: true
        ]

        save(query: query, onSuccess: onSuccess, onFailure: onFailure)
    }

    public func get(key: String,
                    onSuccess: @escaping (_ success: Any?) -> Void,
                    onFailure: @escaping (_ error: Error) -> Void) {

        let query: [NSString: Any] = [
            kSecClass: kSecClassCertificate,
            kSecAttrLabel: key,
            kSecReturnRef: true
        ]

        let (status, result) = get(query: query)

        if status == errSecSuccess, let result = result {
            onSuccess(result)
        } else {
            Logger.print("❌❌ Identity not found, error: \(status)")
            onFailure(GenericDomainError(type: .notFound))
        }
    }

    public func delete(key: String,
                       onSuccess: @escaping () -> Void,
                       onFailure: @escaping (_ error: Error) -> Void) {

        Logger.print("ℹ️ℹ️ Deleting certificate in the keychain with label \(key)")

        let query: [NSString: Any] = [
            kSecClass: kSecClassCertificate,
            kSecAttrLabel: key,
            kSecReturnAttributes: true
        ]

        delete(query: query, onSuccess: onSuccess, onFailure: onFailure)
    }

    public func clear(onSuccess: @escaping () -> Void,
                      onFailure: @escaping (_ error: Error) -> Void) {

        Logger.print("ℹ️ℹ️ Clearing all certificates in the keychain")

        let query = [
            kSecClass: kSecClassCertificate
        ]

        delete(query: query, onSuccess: onSuccess, onFailure: onFailure)
    }

}
