import WatchKit
import Foundation
import SwiftUI
import CalendarishCoreWatch
import WatchConnectivity
import Combine

class HostingController : WKHostingController<EventListView> {

    let store = EventStore()
    let shortcutController = ShortcutController()
    fileprivate var shortcutSubscription: AnyCancellable?

    override init() {
        super.init()
        shortcutSubscription = store.didChange.assign(to: \.events, on: shortcutController)
    }

    override var body: EventListView {
        return EventListView(store: store)
    }

}

