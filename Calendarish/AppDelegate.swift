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
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    fileprivate lazy var authorizationController: AuthorizationController = {
        let controller = AuthorizationController(targetWindow: window!)
        return controller
    }()
    let watchController = WatchController(session: WCSession.default)
    fileprivate var authorizationSubscription: AnyCancellable?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Use a UIHostingController as window root view controller
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = UIHostingController(rootView: ContentView(authorizationController: authorizationController))
        authorizationSubscription = authorizationController.authorizationPublisher.assertNoFailure().sink { authorization in
            self.watchController.addAuthorization(authorization: authorization)
        }
        window.makeKeyAndVisible()
        return true
    }

}
