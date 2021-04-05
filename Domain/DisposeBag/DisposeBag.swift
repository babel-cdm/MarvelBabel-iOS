//
//  DisposeBag.swift
//  Domain
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation

public protocol Disposable {
    func disposed(by bag: DisposeBag)
    func dispose()
}

public class DisposeBag {

    public init() {

    }

}

public let disposeBagNotificationId = NSNotification.Name(rawValue: "disposeBagNotificationId")
public let disposeBagNotificationParameter = "disposeBagNotificationParameter"
