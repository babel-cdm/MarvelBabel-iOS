//
//  BasePresenter.swift
//  MarvelBabel
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import Foundation
import Domain

public protocol BasePresenterProtocol: class {
    func didLoad()
    func willAppear()
    func didAppear()
    func willDisappear()
    func didDisappear()
    func onNavBarLeftButtonClicked(_ isCustom: Bool)
    func onNavBarRightButtonClicked(_ tag: Int)
    func handlePopBeganGesture()
    func handlePopEndedGesture()
    func handleDismissEndedGesture()
}

private protocol BasePresenterDependencies: class {
    associatedtype View
    associatedtype Router

    func getView() -> View?
    func getRouter() -> Router?
}

/**
 Base presenter.

 # Generic Parameters
 - View: View protocol parameter.
 - Router: Router protocol parameter.
 */
open class BasePresenter<View, Router>: BasePresenterDependencies {

    // MARK: - Properties

    /**
     DisposeBag to use in the interactors.
     It is required for the interactor to know when the Presenter disinstates.
     */
    public var disposeBag: DisposeBag

    // MARK: - VIPER Dependencies

    internal weak var view: BaseViewProtocol?
    internal let router: BaseWireframeProtocol

    /**
     Obtain the view protocol casted to 'View' type.
     */
    public func getView() -> View? {
        return view as? View
    }

    /**
     Obtain the router protocol casted to 'Router' type.
     */
    public func getRouter() -> Router? {
        return router as? Router
    }

    // MARK: - Initializer

    /**
     Initializer of DisposeBag, 'View' and 'Router'
     */
    public init(view: BaseViewProtocol, router: BaseWireframeProtocol) {
        self.disposeBag = DisposeBag()
        self.view = view
        self.router = router
    }

    /**
     Deinit method that sends a notification to Interactor, warning that the Presenter is going to disinstantiate.
     */
    deinit {
        NotificationCenter.default.post(name: disposeBagNotificationId,
                                        object: nil,
                                        userInfo: [disposeBagNotificationParameter: disposeBag])
    }

    // MARK: - BasePresenterProtocol

    /**
     Called when `viewDidLoad()` function of ViewController is called.
     */
    open func didLoad() {}

    /**
     Called when `viewWillAppear(_:)` function of ViewController is called.
     */
    open func willAppear() {}

    /**
     Called when `viewDidAppear(_:)` function of ViewController is called.
     */
    open func didAppear() {}

    /**
     Called when `viewWillDisappear(_:)` function of ViewController is called.
     */
    open func willDisappear() {}

    /**
     Called when `viewDidDisappear(_:)` function of ViewController is called.
     */
    open func didDisappear() {}

    /**
     Called when the left button of NavigationController is clicked.
     By default, this function go back in the Router.
     */
    open func onNavBarLeftButtonClicked(_ isCustom: Bool) {
        if isCustom {
            router.pop(animated: true)
        } else {
            router.popGesture()
        }
    }

    /**
     Called when the right buttons of NavigationController are clicked.

     - Parameter tag: This parameter is used to differentiate which button has been pressed.
     */
    open func onNavBarRightButtonClicked(_ tag: Int) {}

    /**
     Called when the user begins the "pop" closing gesture.
     */
    open func handlePopBeganGesture() {}

    /**
     Called when the user finishes the "pop" closing gesture.
     */
    open func handlePopEndedGesture() {
        router.popGesture()
    }

    /**
     Called when the user finishes the "dismiss" closing gesture.
     */
    open func handleDismissEndedGesture() {
        router.dismissGesture()
    }

}
