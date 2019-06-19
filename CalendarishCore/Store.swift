import Foundation
import GoogleAPIClientForREST
import Combine
import SwiftUI

public class Store {

    public let authenticator: Authenticator
    public private(set) var events: [Event] = []

    fileprivate let calendarService = GTLRCalendarService()
    fileprivate var subscription: AnyCancellable? = nil

    public init(authenticator: Authenticator) {
        self.authenticator = authenticator
        calendarService.authorizer = authenticator.authorization
        subscription = eventPublisher.assign(to: \.events, on: self)
    }

}

extension Store: BindableObject {

    public var didChange: AnyPublisher<[Event], Never> {
        return eventPublisher
    }

}

extension Store {

    var eventPublisher: AnyPublisher<[Event], Never> {
        return calendarList().flatMap { calendars -> Publishers.MergeMany<Publishers.Future<[Event], Error>> in
            let events = calendars.map { calendar in
                self.events(in: calendar)
            }
            return Publishers.MergeMany(events)
            }
            .assertNoFailure()
            .replaceError(with: [])
            .reduce([], +)
            .eraseToAnyPublisher()
    }

}

extension Store {

    func calendarList() -> Publishers.Future<[Calendar], Error> {
        return Publishers.Future { promise in
            let query = GTLRCalendarQuery_CalendarListList.query()
            self.calendarService.executeQuery(query) { _, any, error in
                guard error == nil else { promise(.failure(.serverError(error!))); return }
                guard let list = any as? GTLRCalendar_CalendarList, let items = list.items else { promise(.failure(.invalidResponse(any))); return }
                let calendars = items.map({ Calendar($0)})
                promise(.success(calendars))
            }
        }
    }

    func events(in calendar: Calendar) -> Publishers.Future<[Event], Error> {
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
                let events = items.map({ Event($0, calendar: calendar) })
                promise(.success(events))
            }
        }
    }

}

extension Store {

    enum Error: Swift.Error {
        case invalidResponse(Any?)
        case serverError(Swift.Error)
    }

}
