//
//  CharacterListCell.swift
//  MarvelBabel
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import UIKit
import SDWebImage

internal class CharacterListCell: BaseTableViewCell {

    // MARK: - IBOutlet

    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    // MARK: - Lifecycle

    override internal func awakeFromNib() {
        super.awakeFromNib()
        highlightColor = .cyan
        disclosureIndicatorColor = .orange
    }

    // MARK: - Functions

    internal func bind(_ viewModel: CharacterCellViewModel) {
        coverImageView.sd_setImage(with: URL(string: viewModel.coverUrl),
                                   placeholderImage: UIImage(named: "characterlist_placeholder"),
                                   options: [.allowInvalidSSLCertificates])
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }

}
