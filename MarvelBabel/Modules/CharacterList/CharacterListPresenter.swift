//
//  CharacterListPresenter.swift
//  MarvelBabel
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation
import Domain

internal protocol CharacterListPresenterProtocol: BasePresenterProtocol,
                                                  BaseTableViewDataSource,
                                                  BaseTableViewDelegate {
    func onErrorRetryClicked()
}

internal final class CharacterListPresenter: BasePresenter<CharacterListViewProtocol, MainWireframeProtocol>, CharacterListPresenterProtocol {
    
    // MARK: - Properties

    private static let characterSection = Int.zero
    private static let limitPageRequested = 20
    private static let cellsBeforeReload = 3

    private let getCharactersPagedInteractor: GetCharactersPagedInteractor
    private var characterPagedDomainModel: CharacterPagedDomainModel?
    private var offset = Int.zero
    private var askingData = false
    private var errorHappened = false
    private var isShowingLoadingRow = false

    private var totalCharacters: Int {
        return characterPagedDomainModel?.total ?? .zero
    }
    private var totalCharactersLoaded: Int {
        return characterPagedDomainModel?.characters.count ?? .zero
    }
    private var isAllLoaded: Bool {
        return offset >= totalCharacters
    }

    // MARK: - Initializer

    internal init(view: CharacterListViewProtocol,
                  router: MainWireframeProtocol,
                  getCharactersPagedInteractor: GetCharactersPagedInteractor) {
        self.getCharactersPagedInteractor = getCharactersPagedInteractor
        super.init(view: view, router: router)
    }

    // MARK: - CharacterListPresenterProtocol

    override internal func didLoad() {
        super.didLoad()
        requestCharactersShowingLoading()
    }

    internal func onErrorRetryClicked() {
        errorHappened = false
        requestCharactersShowingLoading()
    }

    private func requestCharactersShowingLoading() {
        getView()?.showLoading()
        requestCharacters()
    }

    private func requestCharacters() {
        askingData = true
        getCharactersPagedInteractor
            .execute(CharacterPagedInteractorParameter(offset: offset,
                                                       limit: CharacterListPresenter.limitPageRequested),
                     onSuccess: { [weak self] characterPagedDomainModel in
                        guard let strongSelf = self else {
                            return
                        }

                        if strongSelf.characterPagedDomainModel == nil {
                            strongSelf.characterPagedDomainModel = characterPagedDomainModel
                        } else {
                            strongSelf.characterPagedDomainModel?.characters.append(contentsOf: characterPagedDomainModel.characters)
                        }

                        strongSelf.askingData = false
                        strongSelf.isShowingLoadingRow = true
                        strongSelf.offset = strongSelf.characterPagedDomainModel?.characters.count ?? .zero

                        strongSelf.getView()?.hideLoading()
                        strongSelf.getView()?.updateCharacterList(CharacterListViewModel(strongSelf.characterPagedDomainModel!))
                     },
                     onFailure: { [weak self] error in
                        Logger.print("CharacterListPresenter - Error: \(error.localizedDescription)")
                        guard let strongSelf = self else {
                            return
                        }

                        strongSelf.askingData = false
                        strongSelf.errorHappened = true
                        strongSelf.getView()?.hideLoading()
                        strongSelf.getView()?.showError()
                        if strongSelf.isShowingLoadingRow {
                            strongSelf.getView()?.hideLoadingRow(section: CharacterListPresenter.characterSection)
                            strongSelf.isShowingLoadingRow = false
                        }
                     })
            .disposed(by: disposeBag)
    }

    // MARK: - TableViewDataSource

    internal func numberOfRowsInSection(_ tableViewTag: Int, _ section: Int) -> Int {
        let loadingRow = (!isAllLoaded && !errorHappened) ? 1 : .zero
        return totalCharactersLoaded + loadingRow
    }

    internal func titleForHeaderInSection(_ tableViewTag: Int, _ section: Int) -> String? {
        return String(format: "CharacterList.Header".localized, String(totalCharacters))
    }

    // MARK: - TableViewDelegate

    internal func willDisplay(_ tableViewTag: Int, _ indexPath: IndexPath) {
        if !isAllLoaded && !errorHappened && !askingData &&
            indexPath.row >= totalCharactersLoaded - CharacterListPresenter.cellsBeforeReload {
            requestCharacters()
        }
    }

    internal func didSelectRowAt(_ tableViewTag: Int, _ indexPath: IndexPath) {
        if let characterPagedDomainModel = characterPagedDomainModel,
           indexPath.row < characterPagedDomainModel.characters.count {
            getRouter()?.toCharacterDetail(characterDomainModel: characterPagedDomainModel.characters[indexPath.row])
        }
    }

}
