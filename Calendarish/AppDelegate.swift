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
import AppAuth
import AuthenticationServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Use a UIHostingController as window root view controller
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIHostingController(rootView: ContentView(userAgent: self))
        self.window = window
        window.makeKeyAndVisible()
                                    
        return true
    }

}

extension AppDelegate: OIDExternalUserAgent {

    func present(_ request: OIDExternalUserAgentRequest, session: OIDExternalUserAgentSession) -> Bool {
        let authViewController = ASWebAuthenticationSession(url: request.externalUserAgentRequestURL(), callbackURLScheme: Constants.redirectURIScheme) { url, error in
            if let url = url {
                session.resumeExternalUserAgentFlow(with: url)
            } else if let error = error {
                session.failExternalUserAgentFlowWithError(error)
            }
        }
        authViewController.presentationContextProvider = self
        authViewController.start()
        return true
    }

    func dismiss(animated: Bool, completion: @escaping () -> Void) {
        // This is automatic with ASWebAuthenticationSession
        completion()
    }

}

extension AppDelegate: ASWebAuthenticationPresentationContextProviding {

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return window!
    }

}
