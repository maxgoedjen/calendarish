import SwiftUI
import CalendarishCore

struct MainView: View {

    @State var accountStore: AccountStore
    @State var eventStore: EventStore

    var body: some View {
        return EventListView(store: eventStore)
        .contextMenu {
            NavigationLink(destination: AccountListView(store: accountStore)) {
                VStack {
                    Image(systemName: "list.bullet")
                    Text("Accounts")
                }
            }
            Button(action: {
                // TODO: https://github.com/maxgoedjen/calendarish/issues/11
            }) {
                VStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Refresh")
                }
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






