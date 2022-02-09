//
//  AppDelegate.swift
//  65AppsEducation-Andreev
//
//  Created by Илья Андреев on 08.10.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var mainCoordinator: mhCoordinatable?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().tintColor = Colors.mhLabelGray
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: Colors.mhLabelGray,
                NSAttributedString.Key.font: UIFont(name: Fonts.openSansRomanSemiBold, size: 17)!
            ],
            for: .normal
        )
        
        UINavigationBar.appearance().backgroundColor = .white
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(
            UIOffset(
                horizontal: -1000.0,
                vertical: 0.0
            ),
            for: .default
        )
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Colors.mhLabelGray,
            NSAttributedString.Key.font: UIFont(name: Fonts.openSansRomanSemiBold, size: 17)!
        ]
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().tintColor = Colors.mhRed
        UITabBarItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont(name: Fonts.openSansRomanSemiBold, size: 14)!
            ],
            for: .normal
        )
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.overrideUserInterfaceStyle = .light
        
        let firebaser: mhFirebaser = .init()
        firebaser.start()
        let databaser: mhDatabaser = .init()
        let mainStrategy: mhStrategy = .init(
            networkManager: NetworkManager(),
            urlGenerator: URLGenerator(
                privateKey: Keys.privateKey,
                publicKey: Keys.publicKey,
                baseURL: Keys.baseURL,
                hasher: MD5
            ),
            firebaser: firebaser,
            databaser: databaser
        )
        
        mainCoordinator = mhMainCoordinator(
            factory: mhScreensFactory(
                strategy: mainStrategy
            ),
            strategy: mainStrategy,
            window: window!
        ) {
            print()
        }
        mainCoordinator?.start()
        window?.makeKeyAndVisible()
        return true
    }
}
