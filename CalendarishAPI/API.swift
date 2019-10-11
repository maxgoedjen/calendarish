import Foundation
import Combine
import SwiftUI
#if os(iOS)
import GoogleAPIClientForREST
import CalendarishCore
#elseif os(watchOS)
import CalendarishCoreWatch
#endif

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
            return Fail<[Event], Error>(error: .signedOut)
                .eraseToAnyPublisher()

        }
        return
            calendarList().flatMap { calendars -> Publishers.MergeMany<Future<[CalendarishCore.Event], Error>> in
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

    func calendarList() -> Future<[CalendarishCore.Calendar], Error> {
        return Future { promise in
            let query = GTLRCalendarQuery_CalendarListList.query()
            self.calendarService.executeQuery(query) { _, any, error in
                guard error == nil else { promise(.failure(.serverError(error!))); return }
                guard let list = any as? GTLRCalendar_CalendarList, let items = list.items else { promise(.failure(.invalidResponse(any))); return }
                let calendars = items.map({ CalendarishCore.Calendar($0)})
                promise(.success(calendars))
            }
        }
    }

    func events(in calendar: CalendarishCore.Calendar) -> Future<[CalendarishCore.Event], Error> {
        return Future { promise in
            let query = GTLRCalendarQuery_EventsList.query(withCalendarId: calendar.identifier)
            let today = Date()
            query.timeMin = GTLRDateTime(date: today)
            if let nextWeek = Foundation.Calendar.autoupdatingCurrent.date(byAdding: .day, value: 7, to: today, wrappingComponents: false) {
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
