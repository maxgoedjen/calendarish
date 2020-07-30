import SwiftUI
import GoogleAPIClientForREST_Calendar
import CalendarishCore
typealias CalendarishCalendar = CalendarishCore.Calendar

extension CalendarishCalendar {

    init?(_ calendar: GTLRCalendar_CalendarListEntry) {
        // Until https://github.com/maxgoedjen/calendarish/issues/1 is fixed
        // Only adding calendars that you own.
        guard calendar.accessRole == "owner" else { return nil }
        self.init(identifier: calendar.identifier!, name: calendar.summary!, color: calendar.backgroundColor!)
    }

}

extension Event {

    init?(_ event: GTLRCalendar_Event, calendar: CalendarishCalendar) {
        guard let identifier = event.identifier else {
            return nil
            
        }
        self.init(identifier:  identifier,
                  name: event.summary!,
                  startTime: event.start?.dateTime?.date ?? event.start?.date?.date ?? Date(),
                  endTime: event.end?.dateTime?.date ?? event.end?.date?.date ?? Date(),
                  attendees: (event.attendees ?? []).compactMap({ Attendee($0) }),
                  description: event.descriptionProperty,
                  location: event.location,
                  calendar: calendar)
    }

}

extension Attendee {

    init?(_ attendee: GTLRCalendar_EventAttendee) {
        self.init(identifier: attendee.email!,
                  name: attendee.displayName ?? attendee.email!,
                  email: attendee.email!,
                  response: Response(rawValue: attendee.responseStatus!)!
                  )
    }

}
