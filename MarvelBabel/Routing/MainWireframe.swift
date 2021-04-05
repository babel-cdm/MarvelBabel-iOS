//
//  MainWireframe.swift
//  MarvelBabel
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import UIKit
import Domain

internal protocol MainWireframeProtocol: BaseWireframeProtocol {
    func toCharacterList()
    func toCharacterDetail(characterDomainModel: CharacterDomainModel)
}

internal class MainWireframe: BaseWireframe, MainWireframeProtocol {

    internal func toCharacterList() {
        if var view = getViewFromStoryboard(name: CharacterListViewController.identifier) as? CharacterListViewController {
            super.pushRoot(view: view)
            let presenter = DependencyInjector.shared
                .getCharacterListPresenter(view: view, router: self)
            view.bind(to: presenter)
        }
    }

    internal func toCharacterDetail(characterDomainModel: CharacterDomainModel) {
        if var view = getViewFromStoryboard(name: CharacterDetailViewController.identifier) as? CharacterDetailViewController {
            super.push(view: view)
            let presenter = DependencyInjector.shared
                .getCharacterDetailPresenter(view: view, router: self,
                                             characterDomainModel: characterDomainModel)
            view.bind(to: presenter)
        }
    }

}
