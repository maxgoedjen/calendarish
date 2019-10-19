import WatchKit
import Foundation
import SwiftUI
import CalendarishCore
import WatchConnectivity
import Combine
import CalendarishAPI
import UserNotifications

class HostingController : WKHostingController<MainView> {

    let eventStore = EventStore()
    let accountStore = AccountStore()
    let shortcutController = ShortcutController()
    var batchAPI: BatchAPI
    fileprivate var subscriptions: [AnyCancellable] = []

    override init() {
        let apis = accountStore.accounts.map({ API(account: $0) })
        batchAPI = BatchAPI(apis: apis)
        super.init()
        WCSession.default.delegate = self
        WCSession.default.activate()
        subscriptions.append(eventStore.$events.assign(to: \.events, on: shortcutController))
        subscriptions.append(batchAPI.eventPublisher.breakpointOnError().replaceError(with: []).assign(to: \.events, on: self.eventStore))
        subscriptions.append(eventStore.$events.sink { _ in
            let server = CLKComplicationServer.sharedInstance()
            for complication in server.activeComplications ?? [] {
                server.reloadTimeline(for: complication)
            }
        })
    }

    override var body: MainView {
        return MainView(accountStore: accountStore, eventStore: eventStore, api: batchAPI)
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
