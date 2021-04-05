//
//  CoroutineError.swift
//  Domain
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation

public enum CoroutineError: Error {
    case mainThread
    case timedOut
    case unknown(_ description: String)
}
