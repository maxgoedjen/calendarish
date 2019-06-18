import Foundation
import GoogleAPIClientForREST
import Combine

public struct Store {

    public let authenticator: Authenticator

    fileprivate let calendarService = GTLRCalendarService()


    public init(authenticator: Authenticator) {
        self.authenticator = authenticator
        calendarService.authorizer = authenticator.authorization
    }

}

extension Store {

    public var eventPublisher: AnyPublisher<[Event], Never> {
        return calendarList().flatMap { calendars -> Publishers.MergeMany<Publishers.Future<[Event], Error>> in
            let events = calendars.map { calendar in
                self.events(in: calendar)
            }
            return Publishers.MergeMany(events)
            }
            .replaceError(with: [])
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
