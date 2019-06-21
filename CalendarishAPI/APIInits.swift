import GoogleAPIClientForREST
import SwiftUI
import CalendarishCore

extension CalendarishCore.Calendar {

    init(_ calendar: GTLRCalendar_CalendarListEntry) {
        // TODO: Hex color parse
        self.init(identifier: calendar.identifier!, name: calendar.summary!)
    }

}

extension CalendarishCore.Event {

    init(_ event: GTLRCalendar_Event, calendar: CalendarishCore.Calendar) {
        self.init(identifier:  event.identifier!, name: event.summary!, startTime: event.start?.dateTime?.date ?? Date(), endTime: event.end?.dateTime?.date ?? Date(), calendar: calendar)
    }

}
