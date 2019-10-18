import SwiftUI
import CalendarishCore
import CalendarishAPI

struct MainView: View {

    @ObservedObject var accountStore: AccountStore
    @ObservedObject var eventStore: EventStore
    var api: APIProtocol

    var body: some View {
        Group {
            if accountStore.accounts.isEmpty {
                ConnectPromptView()
            } else {
                EventListView(store: eventStore)
                .contextMenu {
                    NavigationLink(destination: AccountListView(store: accountStore)) {
                        VStack {
                            Image(systemName: "list.bullet")
                            Text("Accounts")
                        }
                    }
                    Button(action: api.reload) {
                        VStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Refresh")
                        }
                    }
                }
            }
        }
    }
}

#if DEBUG
struct MainView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            MainView(accountStore: AccountStore.sampleStore, eventStore: EventStore.sampleStore, api: BatchAPI(apis: []))
            MainView(accountStore: AccountStore(), eventStore: EventStore.sampleStore, api: BatchAPI(apis: []))

        }
    }
}
#endif







