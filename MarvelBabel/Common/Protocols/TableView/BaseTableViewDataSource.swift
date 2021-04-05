//
//  BaseTableViewDataSource.swift
//  MarvelBabel
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation

/**
 Base table view data source.
 */
@objc public protocol BaseTableViewDataSource: class {
    func numberOfRowsInSection(_ tableViewTag: Int, _ section: Int) -> Int
    @objc optional func numberOfSections(_ tableViewTag: Int) -> Int
    @objc optional func canEditRowAt(_ tableViewTag: Int, _ indexPath: IndexPath) -> Bool
    @objc optional func canMoveRowAt(_ tableViewTag: Int, _ indexPath: IndexPath) -> Bool
    @objc optional func commit(_ tableViewTag: Int, editingStyle: BaseTableView.CellEditingStyle, forRowAt indexPath: IndexPath)
    @objc optional func moveRowAt(_ tableViewTag: Int, sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    @objc optional func titleForHeaderInSection(_ tableViewTag: Int, _ section: Int) -> String?
    @objc optional func titleForFooterInSection(_ tableViewTag: Int, _ section: Int) -> String?
    @objc optional func sectionForSectionIndexTitle(_ tableViewTag: Int, title: String, at index: Int) -> Int
}
