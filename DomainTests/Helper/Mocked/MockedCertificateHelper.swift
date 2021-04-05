//
//  MockedCertificateHelper.swift
//  DomainTests
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import XCTest
@testable import Domain

public enum MockedCertificateHelperResponse {
    case success
    case failure
}

public class MockedCertificateHelper: CertificateHelper {

    // MARK: - Properties

    public var result: MockedCertificateHelperResponse = .success
    public var importAppCertificatesCalled: Bool = false
    public var removeAllCertificatesCalled: Bool = false

    public init() {
        super.init(keychainRepository: MockedKeychainRepository())
    }

    override public func importAppCertificates(bundle: Bundle = Bundle.main,
                                               onSuccess: (() -> Void)? = nil,
                                               onFailure: ((_ error: Error) -> Void)? = nil) {
        importAppCertificatesCalled = true

        switch result {
        case .success:
            onSuccess?()
        case .failure:
            onFailure?(GenericDomainError(type: .unknown))
        }
    }

    override public func removeAllCertificates(onSuccess: (() -> Void)? = nil,
                                               onFailure: ((_ error: Error) -> Void)? = nil) {
        removeAllCertificatesCalled = true

        switch result {
        case .success:
            onSuccess?()
        case .failure:
            onFailure?(GenericDomainError(type: .unknown))
        }
    }
}
