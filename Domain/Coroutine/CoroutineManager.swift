//
//  CoroutineManager.swift
//  Domain
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation

public class CoroutineManager {

    public typealias Producer<T> = (_ consumer: @escaping Consumer<T>) -> Void
    public typealias Consumer<T> = (_ object: T) -> Void

    public init() {}

    public func execute<T>(timeOutSeconds: Int? = nil, producer: @escaping Producer<T>) throws -> T {
        var result: T?

        guard !Thread.isMainThread else {
            Logger.print("------- Error: CoroutineManager executed on the Main Thread. -------")
            throw CoroutineError.mainThread
        }

        let semaphore = DispatchSemaphore(value: .zero)
        DispatchQueue.global(qos: .background).async {
            let consumer: Consumer<T> = { object in
                result = object
                semaphore.signal()
            }
            producer(consumer)
        }

        if let timeOutSeconds = timeOutSeconds {
            let timeOut = DispatchTime.now() + .seconds(timeOutSeconds)
            if semaphore.wait(timeout: timeOut) == .timedOut {
                Logger.print("------- Error: CoroutineManager Timed Out. -------")
                throw CoroutineError.timedOut
            }
        } else {
            semaphore.wait()
        }

        guard let finalResult = result else {
            throw CoroutineError.unknown("------- Error: CoroutineManager with Result NULL. -------")
        }

        return finalResult
    }

}
