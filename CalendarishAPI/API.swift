import Foundation
import Combine
import SwiftUI
import GoogleAPIClientForREST
import GTMSessionFetcher
import CalendarishCore
import GTMAppAuth

public struct API {

    fileprivate let calendarService = GTLRCalendarService()

    public init(account: Account) {
        let authorizer = try! NSKeyedUnarchiver.unarchivedObject(ofClass: GTMAppAuthFetcherAuthorization.self, from: account.authorization)
        calendarService.authorizer = authorizer
    }

}

extension API {

    public var eventPublisher: AnyPublisher<[Event], Error> {
        return
            calendarList().flatMap { calendars -> Publishers.MergeMany<Future<[Event], Error>> in
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

    func calendarList() -> Future<[CalendarishCalendar], Error> {
        return Future { promise in
            let query = GTLRCalendarQuery_CalendarListList.query()
            self.calendarService.executeQuery(query) { _, any, error in
                guard error == nil else { promise(.failure(.serverError(error!))); return }
                guard let list = any as? GTLRCalendar_CalendarList, let items = list.items else { promise(.failure(.invalidResponse(any))); return }
                let calendars = items.map({ CalendarishCalendar($0)})
                promise(.success(calendars))
            }
        }
    }

    func events(in calendar: CalendarishCalendar) -> Future<[Event], Error> {
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
                let events = items.map({ Event($0, calendar: calendar) })
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
