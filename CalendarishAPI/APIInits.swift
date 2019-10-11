import SwiftUI
import GoogleAPIClientForREST
#if os(iOS)
import CalendarishCore
#elseif os(watchOS)
import CalendarishCoreWatch
#endif

extension CalendarishCore.Calendar {

    init(_ calendar: GTLRCalendar_CalendarListEntry) {
        // TODO: Hex color parse
        self.init(identifier: calendar.identifier!, name: calendar.summary!)
    }

}

extension Event {

    init(_ event: GTLRCalendar_Event, calendar: CalendarishCore.Calendar) {
        self.init(identifier:  event.identifier!,
                  name: event.summary!,
                  startTime: event.start?.dateTime?.date ?? Date(),
                  endTime: event.end?.dateTime?.date ?? Date(),
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
