//
//  CharacterDetailPresenter.swift
//  MarvelBabel
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation
import Domain

internal protocol CharacterDetailPresenterProtocol: BasePresenterProtocol {
    func onWikiButtonClicked()
    func onErrorClicked()
}

internal final class CharacterDetailPresenter: BasePresenter<CharacterDetailViewProtocol, MainWireframeProtocol>, CharacterDetailPresenterProtocol {

    // MARK: - Properties

    private var characterDomainModel: CharacterDomainModel
    private let getCharacterDetailInteractor: GetCharacterDetailInteractor

    // MARK: - Initializer

    internal init(view: CharacterDetailViewProtocol,
                  router: MainWireframeProtocol,
                  characterDomainModel: CharacterDomainModel,
                  getCharacterDetailInteractor: GetCharacterDetailInteractor) {
        self.characterDomainModel = characterDomainModel
        self.getCharacterDetailInteractor = getCharacterDetailInteractor
        super.init(view: view, router: router)
    }

    // MARK: - CharacterDetailPresenterProtocol

    override internal func didLoad() {
        super.didLoad()

        getView()?.setTitle(characterDomainModel.name)

        getView()?.showLoading()
        getCharacterDetailInteractor
            .execute(CharacterDetailInteractorParameter(identifier: characterDomainModel.identifier),
                     onSuccess: { [weak self] characterDomainModel in
                        guard let strongSelf = self else {
                            return
                        }

                        strongSelf.characterDomainModel = characterDomainModel

                        strongSelf.getView()?.hideLoading()
                        strongSelf.getView()?.displayCharacterDetail(CharacterDetailViewModel(characterDomainModel))
                     },
                     onFailure: { [weak self] error in
                        Logger.print("CharacterDetailPresenter - Error: \(error.localizedDescription)")
                        guard let strongSelf = self else {
                            return
                        }

                        strongSelf.getView()?.hideLoading()
                        strongSelf.getView()?.showError()
                     })
            .disposed(by: disposeBag)
    }

    internal func onWikiButtonClicked() {
        if let url = URL(string: characterDomainModel.wiki) {
            getRouter()?.openUrl(url)
        }
    }

    internal func onErrorClicked() {
        getRouter()?.pop(animated: true)
    }

}
