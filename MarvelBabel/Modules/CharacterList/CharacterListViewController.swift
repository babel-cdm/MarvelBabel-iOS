//
//  CharacterListViewController.swift
//  MarvelBabel
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import UIKit

internal protocol CharacterListViewProtocol: BaseViewProtocol {
    func updateCharacterList(_ characterListViewModel: CharacterListViewModel)
    func showError()
    func hideLoadingRow(section: Int)
}

internal final class CharacterListViewController: BaseViewController<CharacterListPresenterProtocol>, CharacterListViewProtocol {

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: BaseTableView!

    // MARK: - BindableType

    override internal func setupUI() {
        super.setupUI()
        setNavBarTitleString("CharacterList.Title".localized)

        tableView.setupDataSource(getPresenter())
        tableView.setupDelegate(getPresenter())
        tableView.register(UINib(nibName: LoadingCell.identifier, bundle: nil),
                           forCellReuseIdentifier: LoadingCell.identifier)
    }

    // MARK: - CharacterListViewProtocol

    internal func updateCharacterList(_ characterListViewModel: CharacterListViewModel) {
        tableView.reloadData { tableView, indexPath -> UITableViewCell in
            let index = indexPath.row
            if index < characterListViewModel.characters.count {
                if let cell = tableView.dequeueReusableCell(withIdentifier: CharacterListCell.identifier, for: indexPath) as? CharacterListCell {
                    cell.bind(characterListViewModel.characters[index])
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.identifier, for: indexPath) as? LoadingCell {
                    cell.bind()
                    return cell
                }
            }
            return UITableViewCell()
        }
    }

    internal func showError() {
        let acceptAction = UIAlertAction(title: "Common.Accept".localized, style: .cancel, handler: nil)
        let retryAction = UIAlertAction(title: "Common.Retry".localized, style: .default) { [weak self] _ in
            self?.getPresenter()?.onErrorRetryClicked()
        }
        showNativeAlertView(title: "Error.Title".localized,
                            message: "Error.Message".localized,
                            actions: [acceptAction, retryAction])
    }

    internal func hideLoadingRow(section: Int) {
        let totalRows = tableView.numberOfRows(inSection: section)
        let lastIndexPath = IndexPath(row: totalRows - 1, section: section)
        tableView.deleteRows(at: [lastIndexPath], with: .automatic)
    }

}
