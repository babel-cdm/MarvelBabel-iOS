//
//  MockedCharacterDetailViewController.swift
//  MarvelBabelTests
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import XCTest
@testable import MarvelBabel_MOCK

public class MockedCharacterDetailViewController: CharacterDetailViewProtocol {

    // MARK: - Properties

    public var showLoadingExpectation: XCTestExpectation?
    public var hideLoadingExpectation: XCTestExpectation?
    public var showErrorExpectation: XCTestExpectation?
    public var setTitleExpectation: XCTestExpectation?
    public var setTitleParam: String?
    public var displayCharacterDetailExpectation: XCTestExpectation?
    public var displayCharacterDetailParam: CharacterDetailViewModel?

    // MARK: - CharacterDetailViewProtocol

    public func showLoading() {
        showLoadingExpectation?.fulfill()
    }

    public func hideLoading() {
        hideLoadingExpectation?.fulfill()
    }

    public func showError() {
        showErrorExpectation?.fulfill()
    }

    public func setTitle(_ title: String) {
        setTitleParam = title
        setTitleExpectation?.fulfill()
    }

    public func displayCharacterDetail(_ characterDetailViewModel: CharacterDetailViewModel) {
        displayCharacterDetailParam = characterDetailViewModel
        displayCharacterDetailExpectation?.fulfill()
    }

}
