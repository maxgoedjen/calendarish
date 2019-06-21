import Foundation
import Combine
import SwiftUI
import CalendarishCore
import GoogleAPIClientForREST

public struct API {

    public let authenticator: Authenticator
    fileprivate let calendarService = GTLRCalendarService()

    public init(authenticator: Authenticator) {
        self.authenticator = authenticator
        calendarService.authorizer = authenticator.authorization
    }

}

extension API {

    public var eventPublisher: AnyPublisher<[CalendarishCore.Event], Error> {
        guard authenticator.isAuthorized else {
            return Publishers.Fail<[Event], Error>(error: .signedOut)
                .eraseToAnyPublisher()

        }
        return
            calendarList().flatMap { calendars -> Publishers.MergeMany<Publishers.Future<[CalendarishCore.Event], Error>> in
            let events = calendars.map { calendar in
                self.events(in: calendar)
            }
            return Publishers.MergeMany(events)
            }
            .reduce([], +)
            .map({ $0.sorted() })
            .eraseToAnyPublisher()
    }

}

extension API {

    func calendarList() -> Publishers.Future<[CalendarishCore.Calendar], Error> {
        return Publishers.Future { promise in
            let query = GTLRCalendarQuery_CalendarListList.query()
            self.calendarService.executeQuery(query) { _, any, error in
                guard error == nil else { promise(.failure(.serverError(error!))); return }
                guard let list = any as? GTLRCalendar_CalendarList, let items = list.items else { promise(.failure(.invalidResponse(any))); return }
                let calendars = items.map({ CalendarishCore.Calendar($0)})
                promise(.success(calendars))
            }
        }
    }

    func events(in calendar: CalendarishCore.Calendar) -> Publishers.Future<[CalendarishCore.Event], Error> {
        return Publishers.Future { promise in
            let query = GTLRCalendarQuery_EventsList.query(withCalendarId: calendar.identifier)
            let today = Date()
            query.timeMin = GTLRDateTime(date: today)
            if let nextWeek = Foundation.Calendar.autoupdatingCurrent.date(byAdding: .day, value: 7, to: today, wrappingComponents: true) {
                query.timeMax = GTLRDateTime(date: nextWeek)
            }
            self.calendarService.executeQuery(query) { _, any, error in
                guard error == nil else { promise(.failure(.serverError(error!))); return }
                guard let list = any as? GTLRCalendar_Events, let items = list.items else { promise(.failure(.invalidResponse(any))); return }
                let events = items.map({ CalendarishCore.Event($0, calendar: calendar) })
                promise(.success(events))
            }
        }
    }

}

extension API {

    public enum Error: Swift.Error {
        case signedOut
        case invalidResponse(Any?)
        case serverError(Swift.Error)
    }

}
