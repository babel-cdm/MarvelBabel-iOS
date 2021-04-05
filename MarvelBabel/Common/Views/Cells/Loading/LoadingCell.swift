//
//  BaseTableViewCell.swift
//  MarvelBabel
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import UIKit

internal class LoadingCell: BaseTableViewCell {
    
    // MARK: - Properties
    
    private static let marginHorizontal: CGFloat = 130
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    
    override internal func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: .zero, left: LoadingCell.marginHorizontal,
                                      bottom: .zero, right: LoadingCell.marginHorizontal)
    }
    
    // MARK: - Functions
    
    internal func bind() {
        activityIndicator.startAnimating()
    }
    
}
