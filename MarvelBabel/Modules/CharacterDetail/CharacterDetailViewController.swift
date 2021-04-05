//
//  CharacterDetailViewController.swift
//  MarvelBabel
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import UIKit
import SDWebImage

internal protocol CharacterDetailViewProtocol: BaseViewProtocol {
    func setTitle(_ title: String)
    func displayCharacterDetail(_ characterDetailViewModel: CharacterDetailViewModel)
    func showError()
}

internal final class CharacterDetailViewController: BaseViewController<CharacterDetailPresenterProtocol>, CharacterDetailViewProtocol {

    // MARK: - Properties

    private static let coverTransparency: CGFloat = 0.2

    // MARK: - IBOutlet

    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var identifierTitleLabel: UILabel!
    @IBOutlet private weak var identifierValueLabel: UILabel!
    @IBOutlet private weak var descriptionTitleLabel: UILabel!
    @IBOutlet private weak var descriptionValueLabel: UILabel!
    @IBOutlet private weak var comicsTitleLabel: UILabel!
    @IBOutlet private weak var comicsValueLabel: UILabel!
    @IBOutlet private weak var seriesTitleLabel: UILabel!
    @IBOutlet private weak var seriesValueLabel: UILabel!
    @IBOutlet private weak var storiesTitleLabel: UILabel!
    @IBOutlet private weak var storiesValueLabel: UILabel!
    @IBOutlet private weak var wikiButton: UIButton!

    // MARK: - BindableType

    override internal func setupUI() {
        super.setupUI()
        coverImageView.alpha = CharacterDetailViewController.coverTransparency

        identifierTitleLabel.text = "CharacterDetail.Identifier".localized
        descriptionTitleLabel.text = "CharacterDetail.Description".localized
        comicsTitleLabel.text = "CharacterDetail.Comics".localized
        seriesTitleLabel.text = "CharacterDetail.Series".localized
        storiesTitleLabel.text = "CharacterDetail.Stories".localized

        wikiButton.setTitle("CharacterDetail.Button.Wiki".localized, for: .normal)
        wikiButton.setCorners()
        wikiButton.isHidden = true
    }

    // MARK: - CharacterDetailViewProtocol

    internal func setTitle(_ title: String) {
        setNavBarTitleString(title)
    }

    internal func displayCharacterDetail(_ characterDetailViewModel: CharacterDetailViewModel) {
        coverImageView.sd_setImage(with: URL(string: characterDetailViewModel.coverUrl),
                                   placeholderImage: UIImage(named: "characterlist_placeholder"),
                                   options: [.allowInvalidSSLCertificates])
        identifierValueLabel.text = characterDetailViewModel.identifier
        descriptionValueLabel.text = characterDetailViewModel.description
        comicsValueLabel.text = characterDetailViewModel.comicsAmount
        seriesValueLabel.text = characterDetailViewModel.seriesAmount
        storiesValueLabel.text = characterDetailViewModel.storiesAmount

        wikiButton.isHidden = characterDetailViewModel.isWikiButtonHidden
    }

    internal func showError() {
        let alertAction = UIAlertAction(title: "Common.Accept".localized, style: .cancel) { [weak self] _ in
            self?.getPresenter()?.onErrorClicked()
        }
        showNativeAlertView(title: "Error.Title".localized,
                            message: "Error.Message".localized,
                            actions: [alertAction])
    }

}
