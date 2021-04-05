//
//  ImportCertificatesInteractorTests.swift
//  DomainTests
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import XCTest
@testable import Domain

public class ImportCertificatesInteractorTests: XCTestCase {

    private var userDefaultsRepository: MockedUserDefaultsRepository!
    private var certificateHelper: MockedCertificateHelper!
    private var interactor: ImportCertificatesInteractor!
    private let disposeBag = DisposeBag()

    private static let versionStored = "1.0.0_1"

    override public func setUp() {
        super.setUp()
        userDefaultsRepository = MockedUserDefaultsRepository()
        certificateHelper = MockedCertificateHelper()
        initializeInteractor()
    }

    public func testImportCertificatesSameVersionSuccess() {
        initializeInteractor(currentVersion: "1.0.0", currentBuild: "1")
        userDefaultsRepository.result = .success(ImportCertificatesInteractorTests.versionStored)
        let expectation = self.expectation(description: "expectation")
        interactor.execute(onSuccess: {
            XCTAssertFalse(self.certificateHelper.removeAllCertificatesCalled)
            XCTAssertFalse(self.certificateHelper.importAppCertificatesCalled)
            expectation.fulfill()
        }).disposed(by: disposeBag)
        waitForExpectations(timeout: 5, handler: nil)
    }

    public func testImportCertificatesLargerVersionSuccess0() {
        initializeInteractor(currentVersion: "1.0.0", currentBuild: "2")
        userDefaultsRepository.result = .success(ImportCertificatesInteractorTests.versionStored)
        let expectation = self.expectation(description: "expectation")
        interactor.execute(onSuccess: {
            XCTAssertTrue(self.certificateHelper.removeAllCertificatesCalled)
            XCTAssertTrue(self.certificateHelper.importAppCertificatesCalled)
            expectation.fulfill()
        }).disposed(by: disposeBag)
        waitForExpectations(timeout: 5, handler: nil)
    }

    public func testImportCertificatesLargerVersionSuccess1() {
        initializeInteractor(currentVersion: "1.0.1", currentBuild: "1")
        userDefaultsRepository.result = .success(ImportCertificatesInteractorTests.versionStored)
        let expectation = self.expectation(description: "expectation")
        interactor.execute(onSuccess: {
            XCTAssertTrue(self.certificateHelper.removeAllCertificatesCalled)
            XCTAssertTrue(self.certificateHelper.importAppCertificatesCalled)
            expectation.fulfill()
        }).disposed(by: disposeBag)
        waitForExpectations(timeout: 5, handler: nil)
    }

    public func testImportCertificatesLargerVersionSuccess2() {
        initializeInteractor(currentVersion: "1.1.0", currentBuild: "1")
        userDefaultsRepository.result = .success(ImportCertificatesInteractorTests.versionStored)
        let expectation = self.expectation(description: "expectation")
        interactor.execute(onSuccess: {
            XCTAssertTrue(self.certificateHelper.removeAllCertificatesCalled)
            XCTAssertTrue(self.certificateHelper.importAppCertificatesCalled)
            expectation.fulfill()
        }).disposed(by: disposeBag)
        waitForExpectations(timeout: 5, handler: nil)
    }

    public func testImportCertificatesLargerVersionSuccess3() {
        initializeInteractor(currentVersion: "2.0.0", currentBuild: "1")
        userDefaultsRepository.result = .success(ImportCertificatesInteractorTests.versionStored)
        let expectation = self.expectation(description: "expectation")
        interactor.execute(onSuccess: {
            XCTAssertTrue(self.certificateHelper.removeAllCertificatesCalled)
            XCTAssertTrue(self.certificateHelper.importAppCertificatesCalled)
            expectation.fulfill()
        }).disposed(by: disposeBag)
        waitForExpectations(timeout: 5, handler: nil)
    }

    private func initializeInteractor(currentVersion: String = "1.0.0",
                                      currentBuild: String = "1") {
        interactor = ImportCertificatesInteractor(userDefaultsRepository: userDefaultsRepository,
                                                  certificateHelper: certificateHelper,
                                                  currentVersion: currentVersion,
                                                  currentBuild: currentBuild)
    }

}
