import WatchKit
import Foundation
import SwiftUI
import CalendarishCore
import WatchConnectivity
import Combine

class HostingController : WKHostingController<EventListView> {

    let eventStore = EventStore()
    let accountStore = AccountStore()
    let shortcutController = ShortcutController()
    fileprivate var shortcutSubscription: AnyCancellable?

    override init() {
        super.init()
        WCSession.default.delegate = self
        WCSession.default.activate()
        shortcutSubscription = eventStore.didChange.assign(to: \.events, on: shortcutController)
    }

    override var body: EventListView {
        return EventListView(store: eventStore)
    }

}

extension HostingController: WCSessionDelegate {

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let email = message["Email"] as? String else { return }
        guard let authorization = message["Authorization"] as? Data else { return }
        accountStore.accounts[email] = Account(email: email, authorization: authorization)
    }


}
