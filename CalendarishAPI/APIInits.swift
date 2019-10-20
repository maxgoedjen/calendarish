import SwiftUI
import GoogleAPIClientForREST
import CalendarishCore
typealias CalendarishCalendar = CalendarishCore.Calendar

extension CalendarishCalendar {

    init(_ calendar: GTLRCalendar_CalendarListEntry) {
        // TODO: Hex color parse
        self.init(identifier: calendar.identifier!, name: calendar.summary!, color: calendar.backgroundColor!)
    }

}

extension Event {

    init(_ event: GTLRCalendar_Event, calendar: CalendarishCalendar) {
        self.init(identifier:  event.identifier!,
                  name: event.summary!,
                  startTime: event.start?.dateTime?.date ?? event.start?.date?.date ?? Date(),
                  endTime: event.end?.dateTime?.date ?? event.end?.date?.date ?? Date(),
                  attendees: (event.attendees ?? []).map({ Attendee($0) }),
                  description: event.descriptionProperty,
                  location: event.location,
                  calendar: calendar)
    }

}

extension Attendee {

    init(_ attendee: GTLRCalendar_EventAttendee) {
        self.init(identifier: attendee.identifier!,
                  name: attendee.displayName!,
                  response: Response(rawValue: attendee.responseStatus!)!
                  )
    }

}
