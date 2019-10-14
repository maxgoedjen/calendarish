import Foundation
import WatchConnectivity
import GTMAppAuth

struct WatchController {

    let session: WCSession

    init(session: WCSession) {
        self.session = session
    }

}

extension WatchController {

    func addAuthorization(authorization: GTMAppAuthFetcherAuthorization) {
        session.sendMessage(["Authorization" : authorization], replyHandler: nil, errorHandler: nil)
    }

}
