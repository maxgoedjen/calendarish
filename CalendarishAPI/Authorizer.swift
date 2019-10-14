import Foundation
import CalendarishCore
import GTMSessionFetcher

class Authorizer: NSObject {

    let account: Account
    fileprivate var authorizingRequests: [URLRequest] = []

    init(account: Account) {
        self.account = account
    }

}

extension Authorizer: GTMFetcherAuthorizationProtocol {

    func authorizeRequest(_ request: NSMutableURLRequest?, delegate: Any, didFinish sel: Selector) {
    }

    func stopAuthorization() {
        authorizingRequests.removeAll()
    }

    func stopAuthorization(for request: URLRequest) {
    }

    func isAuthorizingRequest(_ request: URLRequest) -> Bool {
        return false
    }

    func isAuthorizedRequest(_ request: URLRequest) -> Bool {
        return true
    }

    var userEmail: String? {
        return account.email
    }


    

}
