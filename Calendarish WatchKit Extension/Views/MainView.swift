import SwiftUI
import CalendarishCore

struct MainView: View {

    @State var accountStore: AccountStore
    @State var eventStore: EventStore

    var body: some View {
        return EventListView(store: eventStore)
        .contextMenu {
            NavigationLink(destination: AccountListView(store: AccountStore.sampleStore)) {
                Text("Accounts")
            }
        }
    }

}

#if DEBUG
struct MainView_Previews : PreviewProvider {
    static var previews: some View {
        MainView(accountStore: AccountStore.sampleStore, eventStore: EventStore.sampleStore)
    }
}
#endif






