//
//  BaseKeychainRepository.swift
//  Data
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation
import Domain

open class BaseKeychainRepository {

    internal func save(query: [NSString: Any],
                       onSuccess: @escaping () -> Void,
                       onFailure: @escaping (_ error: Error) -> Void) {

        var status: OSStatus = SecItemAdd(query as CFDictionary, nil)

        if status == errSecDuplicateItem {
            Logger.print("⚠️⚠️ Identity duplicated in the keychain -> Will replaced")
            SecItemDelete(query as CFDictionary)
            status = SecItemAdd(query as CFDictionary, nil)
            onSuccess()
        } else if status == errSecSuccess {
            onSuccess()
        } else {
            Logger.print("❌❌ Failed to add to the keychain, error: \(status)")
            onFailure(GenericDomainError(type: .unknown, description: status.description))
        }
    }

    internal func get(query: [NSString: Any]) -> (status: OSStatus, result: CFTypeRef?) {

        var result: CFTypeRef?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &result)

        return (status: status, result: result)
    }

    internal func delete(query: [NSString: Any],
                         onSuccess: @escaping () -> Void,
                         onFailure: @escaping (_ error: Error) -> Void) {

        let status: OSStatus = SecItemDelete(query as CFDictionary)

        if status == errSecSuccess {
            onSuccess()
        } else {
            onFailure(GenericDomainError(type: .unknown, description: status.description))
        }
    }

}
