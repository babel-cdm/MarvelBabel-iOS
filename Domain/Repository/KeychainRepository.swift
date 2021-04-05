//
//  KeychainRepository.swift
//  Domain
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation

public protocol KeychainRepository {
    func save(object: Any,
              key: String,
              onSuccess: @escaping () -> Void,
              onFailure: @escaping (_ error: Error) -> Void)
    func get(key: String,
             onSuccess: @escaping (_ success: Any?) -> Void,
             onFailure: @escaping (_ error: Error) -> Void)
    func delete(key: String,
                onSuccess: @escaping () -> Void,
                onFailure: @escaping (_ error: Error) -> Void)
    func clear(onSuccess: @escaping () -> Void,
               onFailure: @escaping (_ error: Error) -> Void)
}
