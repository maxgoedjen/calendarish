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

class HostingController : WKHostingController<ContentView> {
    override var body: ContentView {
        return ContentView(store: Store())
    }
}
