//
//  MockedMainWireframe.swift
//  MarvelBabelTests
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import XCTest
import Domain
@testable import MarvelBabel_MOCK

public class MockedMainWireframe: MainWireframeProtocol {

    // MARK: - Properties

    public var popExpectation: XCTestExpectation?
    public var popParam: Bool?
    public var openUrlExpectation: XCTestExpectation?
    public var openUrlParam: URL?

    // MARK: - MainWireframeProtocol

    public func pop(animated: Bool) {
        popParam = animated
        popExpectation?.fulfill()
    }

    public func popToRoot(animated: Bool) {}

    public func popModalToRoot(animated: Bool) {}

    public func popModal(animated: Bool) {}

    public func dismissModal(animated: Bool, completion: (() -> Void)?) {}

    public func popGesture() {}

    public func dismissGesture() {}

    public func openUrl(_ url: URL) {
        openUrlParam = url
        openUrlExpectation?.fulfill()
    }

    public func toCharacterList() {}

    public func toCharacterDetail(characterDomainModel: CharacterDomainModel) {}

}
