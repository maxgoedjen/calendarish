#if DEBUG
import SwiftUI
import CalendarishCore

extension EventStore {

    static var sampleStore: EventStore {
        return EventStore(events: [
            Event(identifier: UUID().uuidString,
                  name: "Coffee with Marina",
                  startTime: Date(timeIntervalSince1970: -25200),
                  endTime:  Date(timeIntervalSince1970: -23400),
                  attendees: [],
                  description: nil,
                  location: "Menotti's",
                  calendar: CalendarishCore.Calendar(identifier: UUID().uuidString, name: "Home", color: "000000")),
            Event(identifier: UUID().uuidString,
                  name: "iOS Sync",
                  startTime: Date(timeIntervalSince1970: -21600),
                  endTime: Date(timeIntervalSince1970: -19800),
                  attendees: [
                    Attendee(identifier: UUID().uuidString, name: "Max Goedjen", response: .accepted),
                    Attendee(identifier: UUID().uuidString, name: "Aaron Houssney", response: .accepted),
                    Attendee(identifier: UUID().uuidString, name: "Lance Schultz", response: .needsAction),
                    Attendee(identifier: UUID().uuidString, name: "Taylor Blau", response: .needsAction),
                    Attendee(identifier: UUID().uuidString, name: "Kaitlyn Hoang", response: .tentative),
                    Attendee(identifier: UUID().uuidString, name: "Alexa Chernov", response: .declined)
                ],
                  description: "Catch up on projects, go over any high priority isues for next release.",
                  location: "Blue Devils",
                  calendar: CalendarishCore.Calendar(identifier: UUID().uuidString, name: "Work", color: "FFFF00")),
            Event(identifier: UUID().uuidString,
                  name: "Team Lunch",
                  startTime: Date(timeIntervalSince1970: -14400),
                  endTime: Date(timeIntervalSince1970: -10800),
                  attendees: [],
                  description: nil,
                  location: "Blossom",
                  calendar: CalendarishCore.Calendar(identifier: UUID().uuidString, name: "Work", color: "FFFF00")),
            Event(identifier: UUID().uuidString,
                  name: "Interview - Toby Ziegler",
                  startTime: Date(timeIntervalSince1970: 0),
                  endTime: Date(timeIntervalSince1970: 3600),
                  attendees: [],
                  description: "Candidate's profile is in Workday",
                  location: nil,
                  calendar: CalendarishCore.Calendar(identifier: UUID().uuidString, name: "Work", color: "FFFF00")),
            Event(identifier: UUID().uuidString,
                  name: "Dinner with Parents",
                  startTime: Date(timeIntervalSince1970: 7200),
                  endTime: Date(timeIntervalSince1970: 10800),
                  attendees: [],
                  description: nil,
                  location: "Blossom",
                  calendar: CalendarishCore.Calendar(identifier: UUID().uuidString, name: "Home", color: "000000")),

            ])
    }

}

extension AccountStore {

    static var sampleStore: AccountStore {
        return AccountStore(accounts: [
            Account(email: "alice@example.com", authorization: Data()),
            Account(email: "bob@example.com", authorization: Data())
        ])
    }

}
#endif

