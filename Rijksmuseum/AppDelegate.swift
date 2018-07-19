//
//  AppDelegate.swift
//  Rijksmuseum
//
//  Created by Tim Edwards on 17/07/2018.
//  Copyright © 2018 Tim Edwards. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let mainScreen:UIScreen
    let mainWindow = UIWindow()
    let mainFlowCoordinator:MainFlowCoordinator

    override init() {
        mainScreen = UIScreen.main
        self.mainFlowCoordinator = MainFlowCoordinator(screen: mainScreen,
                                                       window: mainWindow)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        mainFlowCoordinator.updateWindow()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
}
