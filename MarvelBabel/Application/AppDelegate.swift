//
//  AppDelegate.swift
//  MarvelBabel
//
//  Copyright © 2021 Babel SI. All rights reserved.
//

import UIKit

@main
internal class AppDelegate: UIResponder, UIApplicationDelegate {

    internal var window: UIWindow?

    internal let importCertificatesInteractor = DependencyInjector.shared.importCertificatesInteractor()

    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        window.makeKeyAndVisible()

        Application.shared.configureMainScreen(in: window)

        importCertificates()

        self.window = window

        return true
    }

}
