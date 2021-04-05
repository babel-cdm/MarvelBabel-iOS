//
//  CertificateHelperTests.swift
//  DomainTests
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import XCTest
@testable import Domain

public class CertificateHelperTests: XCTestCase {

    private var keychainRepository: MockedKeychainRepository!
    private var certificateHelper: CertificateHelper!

    override public func setUp() {
        super.setUp()
        keychainRepository = MockedKeychainRepository()
        certificateHelper = CertificateHelper(keychainRepository: keychainRepository)
    }

    public func testImportAppCertificatesKeychainSuccess() {
        keychainRepository.result = .success
        let expectation = self.expectation(description: "successKeychainExpectation")
        certificateHelper.importAppCertificates(bundle: Bundle(for: self.classForCoder),
                                                onSuccess: {
                                                    expectation.fulfill()
                                                })
        waitForExpectations(timeout: 5, handler: nil)
    }

    public func testImportAppCertificatesKeychainFailure() {
        keychainRepository.result = .failure
        let expectation = self.expectation(description: "failureKeychainExpectation")
        certificateHelper.importAppCertificates(bundle: Bundle(for: self.classForCoder),
                                                onFailure: { _ in
                                                    expectation.fulfill()
                                                })
        waitForExpectations(timeout: 5, handler: nil)
    }

    public func testImportAppCertificatesNotExists() {
        certificateHelper.importAppCertificates(bundle: Bundle.main)
        let expectation = self.expectation(description: "failureExpectation")
        certificateHelper.importAppCertificates(bundle: Bundle.main,
                                                onFailure: { _ in
                                                    expectation.fulfill()
                                                })
        waitForExpectations(timeout: 5, handler: nil)
    }

    public func testRemoveAllCertificatesSuccess() {
        keychainRepository.result = .success
        let expectation = self.expectation(description: "successKeychainExpectation")
        certificateHelper.removeAllCertificates(onSuccess: {
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
    }

    public func testRemoveAllCertificatesFailure() {
        keychainRepository.result = .failure
        let expectation = self.expectation(description: "failureKeychainExpectation")
        certificateHelper.removeAllCertificates(onFailure: { _ in
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
    }

}
