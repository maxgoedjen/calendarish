import SwiftUI
import CalendarishCoreWatch

struct NotificationView : View {

    let event: Event

    var body: some View {
        VStack {
            EventDescriptionView(event: event)
            Button(action: {}) {
                Text("Snooze")
            }
            Button(action: {}) {
                Text("Dismiss")
            }
            EventAttendeeListView(attendees: event.attendees)
        }
    }

}

#if DEBUG
struct NotificationView_Previews : PreviewProvider {
    static var previews: some View {
        ForEach(EventStore.sampleStore.events) { event in
            NotificationView(event: event)
        }.environment(\.colorScheme, .dark)
    }
}
#endif
