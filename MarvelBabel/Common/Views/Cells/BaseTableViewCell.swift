//
//  BaseTableViewCell.swift
//  MarvelBabel
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import UIKit

open class BaseTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    /// Background color when the user keeps his finger on the cell.
    public var highlightColor: UIColor?
    /// Background color when the user selects a row.
    public var selectedBackgroundColor: UIColor?
    /// Tint color of disclosure indicator.
    public var disclosureIndicatorColor: UIColor?
    
    // MARK: - Lifecycle
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if let selectedBackgroundColor = selectedBackgroundColor {
            if selected {
                let selectedBackgroundView = UIView()
                selectedBackgroundView.backgroundColor = selectedBackgroundColor
                
                self.selectedBackgroundView = selectedBackgroundView
            } else {
                self.selectedBackgroundView = nil
            }
        }
    }
    
}
