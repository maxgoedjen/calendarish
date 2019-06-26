import SwiftUI
import CalendarishCoreWatch

struct ContentView : View {

    @State var store: Store
    let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .short
        return f
    }()

    let durationFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.hour, .minute]
        return f
    }()

    var body: some View {
        List(store.events) { event in
            VStack(alignment: .leading) {
                Text(event.name)
                    .font(.headline)
                    .fontWeight(.bold)
                HStack {
                    Text(self.dateFormatter.string(from: event.startTime))
                    Spacer()
                Text(self.durationFormatter.string(from: event.startTime, to: event.endTime)!)
                }
                }
                .padding()
            }.listStyle(.carousel)
    }

}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(events: [
            Event(identifier: UUID().uuidString,
                  name: "Coffee with Marina",
                  startTime: Date(timeIntervalSince1970: -25200),
                  endTime:  Date(timeIntervalSince1970: -23400),
                  attendees: [],
                  description: nil,
                  location: "Menotti's",
                  calendar: CalendarishCoreWatch.Calendar(identifier: UUID().uuidString, name: "Home")),
            Event(identifier: UUID().uuidString,
                  name: "iOS Sync",
                  startTime: Date(timeIntervalSince1970: -21600),
                  endTime: Date(timeIntervalSince1970: -19800),
                  attendees: [],
                  description: "Catch up on projects.",
                  location: "Blue Devils",
                  calendar: CalendarishCoreWatch.Calendar(identifier: UUID().uuidString, name: "Work")),
            Event(identifier: UUID().uuidString,
                  name: "Team Lunch",
                  startTime: Date(timeIntervalSince1970: -14400),
                  endTime: Date(timeIntervalSince1970: -10800),
                  attendees: [],
                  description: nil,
                  location: "Blossom",
                  calendar: CalendarishCoreWatch.Calendar(identifier: UUID().uuidString, name: "Work")),
            Event(identifier: UUID().uuidString,
                  name: "Dinner with Parents",
                  startTime: Date(timeIntervalSince1970: 7200),
                  endTime: Date(timeIntervalSince1970: 10800),
                  attendees: [],
                  description: nil,
                  location: "Blossom",
                  calendar: CalendarishCoreWatch.Calendar(identifier: UUID().uuidString, name: "Home")),

            ]))
    }
}
#endif





