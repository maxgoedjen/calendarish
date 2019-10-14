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
import CalendarishCore
import CalendarishAPI
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Use a UIHostingController as window root view controller
        let window = UIWindow(frame: UIScreen.main.bounds)
        let accountStore = AccountStore()
        let eventStore = EventStore()
        window.rootViewController = UIHostingController(rootView: ContentView(accountStore: accountStore, eventStore: eventStore))
        self.window = window
        window.makeKeyAndVisible()
                                    
        return true
    }


}

