import WatchKit
import Foundation
import SwiftUI
import CalendarishCoreWatch
import WatchConnectivity
import Combine

class HostingController : WKHostingController<EventListView> {

    let store = Store()
    let shortcutController = ShortcutController()
    let sessionProxy = SessionProxy(session: WCSession.default)
    fileprivate var storeSubscription: AnyCancellable?
    fileprivate var shortcutSubscription: AnyCancellable?

    override init() {
        super.init()
        storeSubscription = sessionProxy.messagePublisher
            .assertNoFailure()
            .compactMap { message -> [Event]? in
                if case let .update(events) = message {
                    return events
                } else {
                    assertionFailure()
                    return nil
                }
            }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.events, on: store)
        shortcutSubscription = store.didChange.assign(to: \.events, on: shortcutController)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            do {
                try self.sessionProxy.send(message: .requestUpdate)
            } catch {
//                assertionFailure()
                print(error)
            }
        }
    }

    override var body: EventListView {
        return EventListView(store: store)
    }

}

