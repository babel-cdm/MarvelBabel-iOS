//
//  CharacterDetailPresenterTests.swift
//  MarvelBabelTests
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import XCTest
import Domain
@testable import MarvelBabel_MOCK

public class CharacterDetailPresenterTests: XCTestCase {

    private static let name = "Hero name"
    private static let totalComics = 5
    private static let totalSeries = 2
    private static let totalStories = Int.zero
    private static let wikiUrl = "https://www.wiki.com"

    private var router: MockedMainWireframe!
    private var view: MockedCharacterDetailViewController!
    private var presenter: CharacterDetailPresenter!
    private var getCharacterDetailInteractor: MockedGetCharacterDetailInteractor!

    override public func setUp() {
        super.setUp()

        router = MockedMainWireframe()
        view = MockedCharacterDetailViewController()
        getCharacterDetailInteractor = MockedGetCharacterDetailInteractor()

        presenter = CharacterDetailPresenter(view: view, router: router,
                                             characterDomainModel: CharacterDomainModel(
                                                identifier: .zero,
                                                thumbnailUrl: "",
                                                name: CharacterDetailPresenterTests.name,
                                                description: "",
                                                comics: .zero,
                                                series: .zero,
                                                stories: .zero,
                                                wiki: CharacterDetailPresenterTests.wikiUrl
                                             ),
                                             getCharacterDetailInteractor: getCharacterDetailInteractor)
    }

    public func testDidLoadSuccess() {
        getCharacterDetailInteractor.response = .success(
            CharacterDomainModel(
                identifier: .zero,
                thumbnailUrl: "",
                name: CharacterDetailPresenterTests.name,
                description: "",
                comics: CharacterDetailPresenterTests.totalComics,
                series: CharacterDetailPresenterTests.totalSeries,
                stories: CharacterDetailPresenterTests.totalStories,
                wiki: CharacterDetailPresenterTests.wikiUrl
            )
        )
        let titleExpectation = self.expectation(description: "titleExpectation")
        view.setTitleExpectation = titleExpectation
        let showLoadingExpectation = self.expectation(description: "showLoadingExpectation")
        view.showLoadingExpectation = showLoadingExpectation
        let hideLoadingExpectation = self.expectation(description: "hideLoadingExpectation")
        view.hideLoadingExpectation = hideLoadingExpectation
        let displayCharacterDetailExpectation = self.expectation(description: "displayCharacterDetailExpectation")
        view.displayCharacterDetailExpectation = displayCharacterDetailExpectation

        presenter.didLoad()
        wait(for: [titleExpectation, showLoadingExpectation,
                   hideLoadingExpectation, displayCharacterDetailExpectation],
             timeout: 5)

        XCTAssertEqual(CharacterDetailPresenterTests.name, view.setTitleParam)
        XCTAssertEqual(String(CharacterDetailPresenterTests.totalComics),
                       view.displayCharacterDetailParam?.comicsAmount)
        XCTAssertEqual(String(CharacterDetailPresenterTests.totalSeries),
                       view.displayCharacterDetailParam?.seriesAmount)
        XCTAssertEqual(String(CharacterDetailPresenterTests.totalStories),
                       view.displayCharacterDetailParam?.storiesAmount)
    }

    public func testDidLoadFailure() {
        getCharacterDetailInteractor.response = .failure
        let titleExpectation = self.expectation(description: "titleExpectation")
        view.setTitleExpectation = titleExpectation
        let showLoadingExpectation = self.expectation(description: "showLoadingExpectation")
        view.showLoadingExpectation = showLoadingExpectation
        let hideLoadingExpectation = self.expectation(description: "hideLoadingExpectation")
        view.hideLoadingExpectation = hideLoadingExpectation
        let showErrorExpectation = self.expectation(description: "showErrorExpectation")
        view.showErrorExpectation = showErrorExpectation

        presenter.didLoad()
        wait(for: [titleExpectation, showLoadingExpectation,
                   hideLoadingExpectation, showErrorExpectation],
             timeout: 5)

        XCTAssertEqual(CharacterDetailPresenterTests.name, view.setTitleParam)
    }

    public func testOnWikiButtonClicked() {
        let expectation = self.expectation(description: "expectation")
        router.openUrlExpectation = expectation

        presenter.onWikiButtonClicked()
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertEqual(URL(string: CharacterDetailPresenterTests.wikiUrl), router.openUrlParam)
    }

    public func testOnErrorClicked() {
        let expectation = self.expectation(description: "expectation")
        router.popExpectation = expectation

        presenter.onErrorClicked()
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssertEqual(true, router.popParam)
    }
}
