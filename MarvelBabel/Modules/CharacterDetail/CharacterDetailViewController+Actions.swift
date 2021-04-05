//
//  CharacterDetailViewController+Actions.swift
//  Domain
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation

extension CharacterDetailViewController {

    @IBAction private func onWikiButtonClicked(_ sender: Any) {
        getPresenter()?.onWikiButtonClicked()
    }

}
