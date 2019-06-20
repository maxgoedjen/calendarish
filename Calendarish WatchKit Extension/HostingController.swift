//
//  HostingController.swift
//  Calendarish WatchKit Extension
//
//  Created by Max Goedjen on 6/14/19.
//  Copyright © 2019 Max Goedjen. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI
import CalendarishCoreWatch
import WatchConnectivity
import Combine

class HostingController : WKHostingController<ContentView> {

    let store = Store()
    let sessionProxy = SessionProxy(session: WCSession.default)
    fileprivate var storeSubscription: AnyCancellable?

    override init() {
        super.init()
        storeSubscription = sessionProxy.contextPublisher
            .assertNoFailure()
            .replaceError(with: [])
            .assign(to: \.events, on: store)

    }

    override var body: ContentView {
        return ContentView(store: store)
    }
    
}
