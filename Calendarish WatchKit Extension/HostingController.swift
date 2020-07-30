import WatchKit
import Foundation
import SwiftUI
import CalendarishCore
import WatchConnectivity
import Combine
import CalendarishAPI
import UserNotifications
import ClockKit

class HostingController : WKHostingController<MainView> {

    let eventStore = EventStore()
    let accountStore = AccountStore()
    let settingsStore = SettingsStore()
    let shortcutController = ShortcutController()
    var batchAPI: BatchAPI
    fileprivate var subscriptions: [AnyCancellable] = []

    override init() {
        let apis = accountStore.accounts.map({ API(account: $0) })
        batchAPI = BatchAPI(apis: apis)
        super.init()
        WCSession.default.delegate = self
        WCSession.default.activate()
        subscriptions.append(
            eventStore.$events.assign(to: \.events, on: shortcutController)
        )
        subscriptions.append(
            eventStore.$events.sink { _ in
                let server = CLKComplicationServer.sharedInstance()
                for complication in server.activeComplications ?? [] {
                    server.reloadTimeline(for: complication)
                }
            }
        )
        let userEmails = accountStore.accounts.map { $0.email }
        subscriptions.append(
            batchAPI.eventPublisher
                .breakpointOnError()
                .replaceError(with: [])
                .map { $0.filter { event in
                    !self.settingsStore.showOnlyAcceptedEvents || event.attendees.first(where: { attendee in userEmails.contains(attendee.name) })?.response == .accepted
                    }
                }
                .assign(to: \.events, on: self.eventStore)
        )
    }

    override var body: MainView {
        return MainView(accountStore: accountStore, eventStore: eventStore, settingsStore: settingsStore, api: batchAPI)
    }

}

extension HostingController: WCSessionDelegate {

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let email = message["Email"] as? String else { return }
        guard let authorization = message["Authorization"] as? Data else { return }
        DispatchQueue.main.async {
            self.accountStore.accounts.append(Account(email: email, authorization: authorization))
        }
    }


}
