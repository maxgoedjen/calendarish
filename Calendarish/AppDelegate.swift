//
//  AppDelegate.swift
//  Calendarish
//
//  Created by Max Goedjen on 6/14/19.
//  Copyright © 2019 Max Goedjen. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    fileprivate lazy var authorizationController: AuthorizationController = {
        let controller = AuthorizationController(targetWindow: window!)
        return controller
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Use a UIHostingController as window root view controller
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIHostingController(rootView: ContentView(authorizationController: authorizationController))
        self.window = window
        window.makeKeyAndVisible()
                                    
        return true
    }

}
