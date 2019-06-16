import Foundation
import GoogleAPIClientForREST

public struct Store {

    public let authenticator: Authenticator

    public init(authenticator: Authenticator) {
        self.authenticator = authenticator
    }

    public func updateResults() {
        let x = GTLRCalendarService()
    }
    
}
