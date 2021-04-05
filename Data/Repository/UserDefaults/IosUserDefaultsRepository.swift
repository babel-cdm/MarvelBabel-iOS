//
//  IosUserDefaultsRepository.swift
//  Data
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation
import Domain

public final class IosUserDefaultsRepository: UserDefaultsRepository {

    // MARK: - Singleton

    private static var repositoryInstance: IosUserDefaultsRepository?

    public static func shared(userDefaultsKey: String) -> UserDefaultsRepository {

        if let repositoryInstance = IosUserDefaultsRepository.repositoryInstance {
            return repositoryInstance
        } else {
            IosUserDefaultsRepository.repositoryInstance = IosUserDefaultsRepository(userDefaultsKey: userDefaultsKey)
            return IosUserDefaultsRepository.repositoryInstance!
        }
    }

    internal init(userDefaultsKey: String) {
        self.userDefaultsKey = userDefaultsKey
    }

    // MARK: - Properties

    private let userDefaultsKey: String

    // MARK: - UserDefaultsRepository functions

    public func save(object: Any,
                     key: String,
                     onSuccess: @escaping () -> Void,
                     onFailure: @escaping (_ error: Error) -> Void) {

        let archivedObject = EncryptionHelper.archive(object: object)
        do {
            let encryptedObject = try EncryptionHelper.aesCBCEncrypt(data: archivedObject,
                                                                     key: userDefaultsKey)
            UserDefaults.standard.set(encryptedObject, forKey: key)
            UserDefaults.standard.synchronize()
            onSuccess()
        } catch {
            onFailure(error)
        }
    }

    public func get(key: String,
                    onSuccess: @escaping (_ success: Any?) -> Void,
                    onFailure: @escaping (_ error: Error) -> Void) {
        if let encryptedObject = UserDefaults.standard.object(forKey: key) as? Data {
            do {
                let archivedObject = try EncryptionHelper.aesCBCDecrypt(data: encryptedObject,
                                                                        key: userDefaultsKey)

                onSuccess(EncryptionHelper.unArchive(data: archivedObject))
            } catch {
                onFailure(error)
            }
        } else {
            onFailure(GenericDomainError(type: .notFound))
        }
    }

    public func delete(key: String,
                       onSuccess: @escaping () -> Void,
                       onFailure: @escaping (_ error: Error) -> Void) {
        UserDefaults.standard.removeObject(forKey: key)
        onSuccess()
    }

}
