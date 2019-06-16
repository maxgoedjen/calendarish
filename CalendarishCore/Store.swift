import Foundation
import GoogleAPIClientForREST

public struct Store {

    public let authenticator: Authenticator
    fileprivate let calendarService = GTLRCalendarService()

    public init(authenticator: Authenticator) {
        self.authenticator = authenticator
        calendarService.authorizer = authenticator.authorization
        updateResults()
    }

    public func updateResults() {
        let query = GTLRCalendarQuery_CalendarListList.query()
        calendarService.executeQuery(query) { (ticket, any, error) in
            print(ticket as Any, any as Any, error as Any)
        }
    }
    
}
