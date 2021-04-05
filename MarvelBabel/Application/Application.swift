//
//  Application.swift
//  MarvelBabel
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import UIKit

public final class Application {

    public static let shared = Application()

    private static var window: UIWindow!

    /**
     Configure Main screen with window object.

     - Parameter window: Window object.
     */
    public func configureMainScreen(in window: UIWindow) {
        Application.window = window

        window.rootViewController = Application.getNavigationController()

        MainWireframe().toCharacterList()
    }

    /**
     Get a NavigationController instance.

     #Function Logic
     - If `rootVC` is set, the function returns a NavigationController object as Root ViewController with the param set in the function.
     - If `rootVC` is not set, the function returns the Root ViewController of the Window object. If it does not exist, create a new NavigationController.

     - Parameter rootVC: New Root ViewController.
     */
    public static func getNavigationController(rootVC: UIViewController? = nil) -> UINavigationController {
        if let rootVC = rootVC {
            return UINavigationController(rootViewController: rootVC)
        } else {
            let navigationController = window.rootViewController as? UINavigationController

            if let navigationController = navigationController {
                return navigationController
            } else {
                return UINavigationController()
            }
        }
    }

    /**
     Get app version.
     */
    public static func getAppVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }

    /**
     Get build number.
     */
    public static func getBuildNumber() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
    }

}
