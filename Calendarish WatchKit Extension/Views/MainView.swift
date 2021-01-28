import SwiftUI
import CalendarishCore
import CalendarishAPI

struct MainView: View {

    @ObservedObject var accountStore: AccountStore
    @ObservedObject var eventStore: EventStore
    var settingsStore: SettingsStore

    var api: APIProtocol

    var body: some View {
        Group {
            if accountStore.accounts.isEmpty {
                ConnectPromptView()
            } else {
                EventListView(store: eventStore)
            }
        }
//        .contextMenu(menuItems: {
//            NavigationLink(destination: AccountListView(store: accountStore)) {
//                VStack {
//                    Image(systemName: "list.bullet")
//                    Text("Accounts")
//                }
//            }
//            NavigationLink(destination: SettingsView(settingsStore: settingsStore)) {
//                VStack {
//                    Image(systemName: "gear")
//                    Text("Settings")
//                }
//            }
//            Button(action: api.reload) {
//                VStack {
//                    Image(systemName: "arrow.clockwise")
//                    Text("Refresh")
//                }
//            }
//        }

    }
}

#if DEBUG
struct MainView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            MainView(accountStore: AccountStore.sampleStore, eventStore: EventStore.sampleStore, settingsStore: SettingsStore(), api: BatchAPI(apis: []))
            MainView(accountStore: AccountStore(), eventStore: EventStore.sampleStore, settingsStore: SettingsStore(), api: BatchAPI(apis: []))

        }
    }
}
#endif







