import GoogleAPIClientForREST
import SwiftUI
import CalendarishCore

extension CalendarishCore.Calendar {

    init(_ calendar: GTLRCalendar_CalendarListEntry) {
        // TODO: Hex color parse
        self.init(identifier: calendar.identifier!, name: calendar.summary!, color: Color.red)
    }

}

extension CalendarishCore.Event {

    init(_ event: GTLRCalendar_Event, calendar: CalendarishCore.Calendar) {
        // TODO: Parse date
        self.init(identifier:  event.identifier!, name: event.summary!, startTime: Date(), endTime: Date(), calendar: calendar)
    }

}
