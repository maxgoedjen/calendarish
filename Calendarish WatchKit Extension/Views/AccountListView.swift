import SwiftUI
import CalendarishCore

struct AccountListView: View {

    @ObservedObject var store: AccountStore

    var body: some View {
        List {
            ForEach(store.accounts) { account in
                Text(account.email)
            }.onDelete(perform: {
                self.store.accounts.remove(atOffsets: $0)
            })
        }
    }

}

#if DEBUG
struct AccountListView_Previews : PreviewProvider {
    static var previews: some View {
        AccountListView(store: AccountStore.sampleStore)
    }
}
#endif





