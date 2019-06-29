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
    fileprivate var storeSubscription: AnyCancellable?
    fileprivate var watchSink: AnySubscriber<[Event], Never>?
    fileprivate var sessionProxy = SessionProxy(session: WCSession.default)
    fileprivate var sessionProxySink: AnySubscriber<SessionProxy.Message, SessionProxy.Error>?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Use a UIHostingController as window root view controller
        let window = UIWindow(frame: UIScreen.main.bounds)
        let api = API(authenticator: Authenticator(config: Constants.config))
        let store = Store()
        let publisher = api.eventPublisher
//            .assertNoFailure()
            .replaceError(with: [])
        storeSubscription = publisher.assign(to: \.events, on: store)
        watchSink = publisher.sink { events in
            self.sendUpdate(events: events)
        }.eraseToAnySubscriber()
        sessionProxySink = sessionProxy.messagePublisher.sink { message in
            switch message {
            case .requestUpdate:
                self.sendUpdate(events: store.events)
            case .update:
                assertionFailure()
                break
            }
        }.eraseToAnySubscriber()

        window.rootViewController = UIHostingController(rootView: ContentView(authenticator: api.authenticator, store: store))
        self.window = window
        window.makeKeyAndVisible()
                                    
        return true
    }

    func sendUpdate(events: [Event]) {
        do {
            try self.sessionProxy.send(message: .update(events))
        } catch {
//            assertionFailure(error.localizedDescription)
            print(error)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

