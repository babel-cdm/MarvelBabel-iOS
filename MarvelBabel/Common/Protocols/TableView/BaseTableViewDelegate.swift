//
//  BaseTableViewDelegate.swift
//  MarvelBabel
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation

/**
 Base table view delegate.
 */
@objc public protocol BaseTableViewDelegate: class {
    @objc optional func heightForRowAt(_ tableViewTag: Int, _ indexPath: IndexPath) -> Float
    @objc optional func estimatedHeightForRowAt(_ tableViewTag: Int, _ indexPath: IndexPath) -> Float
    @objc optional func didSelectRowAt(_ tableViewTag: Int, _ indexPath: IndexPath)
    @objc optional func didDeselectRowAt(_ tableViewTag: Int, _ indexPath: IndexPath)
    @objc optional func willDisplay(_ tableViewTag: Int, _ indexPath: IndexPath)
    @objc optional func shouldHighlightRowAt(_ tableViewTag: Int, _ indexPath: IndexPath) -> Bool
    @objc optional func didHighlightRowAt(_ tableViewTag: Int, _ indexPath: IndexPath)
    @objc optional func didUnhighlightRowAt(_ tableViewTag: Int, _ indexPath: IndexPath)
}
