import SwiftUI
import CalendarishCoreWatch

struct ContentView : View {

    @State var store: Store

    var body: some View {
        VStack {
            List(store.events) { event in
                VStack(alignment: .leading) {
                    Text(event.name)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text(DateFormatter().string(from: event.startTime))
                }
            }.listStyle(.carousel)
        }
    }

}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(events: [
            Event(identifier: UUID().uuidString, name: "Coffee with Marina", startTime: Date(), endTime: Date(), calendar: CalendarishCoreWatch.Calendar(identifier: UUID().uuidString, name: "Home")),
            Event(identifier: UUID().uuidString, name: "iOS Sync", startTime: Date(), endTime: Date(), calendar: CalendarishCoreWatch.Calendar(identifier: UUID().uuidString, name: "Work")),
            Event(identifier: UUID().uuidString, name: "Team Lunch", startTime: Date(), endTime: Date(), calendar: CalendarishCoreWatch.Calendar(identifier: UUID().uuidString, name: "Work")),
            Event(identifier: UUID().uuidString, name: "Coffee with Marina", startTime: Date(), endTime: Date(), calendar: CalendarishCoreWatch.Calendar(identifier: UUID().uuidString, name: "Work")),
            Event(identifier: UUID().uuidString, name: "Dinner with Parents", startTime: Date(), endTime: Date(), calendar: CalendarishCoreWatch.Calendar(identifier: UUID().uuidString, name: "Home")),
            ]))
    }
}
#endif


