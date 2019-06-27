import SwiftUI
import CalendarishCoreWatch

struct NotificationView : View {

    let event: Event

    var body: some View {
        EventDetailView(event: event)
    }

}

#if DEBUG
struct NotificationView_Previews : PreviewProvider {
    static var previews: some View {
        NotificationView(event: Store.sampleStore.events[2])
    }
}
#endif
