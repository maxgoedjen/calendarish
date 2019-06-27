#if DEBUG
import SwiftUI
import CalendarishCoreWatch

extension Store {
    static var sampleStore: Store {
        return Store(events: [
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

            ])
    }
}
#endif
