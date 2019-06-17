import GoogleAPIClientForREST
import SwiftUI

extension Calendar {

    init(_ calendar: GTLRCalendar_CalendarListEntry) {
        self.identifier = calendar.identifier!
        self.name = calendar.summary!
        // TODO: Hex color parse
        self.color = Color.red
    }

}

extension Event {

    init(_ event: GTLRCalendar_Event, calendar: Calendar) {
        self.identifier = event.identifier!
        self.name = event.summary!
//        self.startTime = event.
        self.calendar = calendar

        //
        self.startTime = Date()
        self.endTime = Date()

    }

}
