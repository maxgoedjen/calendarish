import WatchKit
import Foundation
import SwiftUI
import CalendarishCore
import WatchConnectivity
import Combine
import CalendarishAPI

class HostingController : WKHostingController<MainView> {

    let eventStore = EventStore()
    let accountStore = AccountStore()
    let shortcutController = ShortcutController()
    fileprivate var subscriptions: [AnyCancellable] = []
    fileprivate var apis: [API] = []
//    fileprivate let eventPublishers: [AnyPublisher<[Event], API.Error>] = []

    override init() {
        super.init()
        WCSession.default.delegate = self
        WCSession.default.activate()
        subscriptions.append(eventStore.$events.assign(to: \.events, on: shortcutController))

        // !!!: Hacks
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let first = self.accountStore.accounts.first {
                let api = API(account: first)
                self.apis.append(api)
                let cancellable = api.eventPublisher.assertNoFailure().replaceError(with: []).assign(to: \.events, on: self.eventStore)
                self.subscriptions.append(cancellable)
            } else {
//                assertionFailure()
            }
        }
    }

    override var body: MainView {
        return MainView(accountStore: accountStore, eventStore: eventStore)
    }

}

extension HostingController: WCSessionDelegate {

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let email = message["Email"] as? String else { return }
        guard let authorization = message["Authorization"] as? Data else { return }
        accountStore.accounts.append(Account(email: email, authorization: authorization))
    }


}
