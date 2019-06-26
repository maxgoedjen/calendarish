import SwiftUI
import CalendarishCoreWatch

struct EventListView: View {

    @State var store: Store
    let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .short
        return f
    }()

    let durationFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.hour, .minute]
        f.formattingContext = .standalone
        return f
    }()

    var body: some View {
        List(store.events) { event in
            NavigationButton(destination: EventDetailView(event: event)) {
                VStack(alignment: .leading) {
                    HStack {
                        Text(self.dateFormatter.string(from: event.startTime))
                        Spacer()
                    Text(self.durationFormatter.string(from: event.startTime, to: event.endTime)!)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    }
                    Text(event.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(nil)
                    Text(event.location ?? "")
                    .italic()
                    Text(event.description ?? "")
                        .font(.footnote)
                        .lineLimit(3)
                    }
                    .padding()
                }
        }
            .listStyle(.carousel)
    }

}

#if DEBUG
struct EventListView_Previews : PreviewProvider {
    static var previews: some View {
        EventListView(store: Store(events: [
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
                  attendees: [
                    Attendee(identifier: UUID().uuidString, name: "Max Goedjen", response: .accepted),
                    Attendee(identifier: UUID().uuidString, name: "Ivan Golub", response: .accepted),
                    Attendee(identifier: UUID().uuidString, name: "Anton Udovychenko", response: .needsAction),
                    Attendee(identifier: UUID().uuidString, name: "Oleksii Gordiienko", response: .tentative),
                    Attendee(identifier: UUID().uuidString, name: "Alexander Gritzuk", response: .declined)
                ],
                  description: "Catch up on projects, go over any high priority isues for next release.",
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
                  name: "Interview - Dmytro Nikolenko",
                  startTime: Date(timeIntervalSince1970: 0),
                  endTime: Date(timeIntervalSince1970: 3600),
                  attendees: [],
                  description: "Candidate's profile is in Workday",
                  location: nil,
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





