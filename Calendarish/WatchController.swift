import Foundation
import WatchConnectivity
import GTMAppAuth

class WatchController: NSObject {

    let session: WCSession

    init(session: WCSession) {
        guard WCSession.isSupported() else {
            fatalError()
        }
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }

}

extension WatchController {

    func addAuthorization(authorization: GTMAppAuthFetcherAuthorization) {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: authorization, requiringSecureCoding: true) else { return }
        session.sendMessage(
            [
            "Authorization" : data,
            "Email": authorization.userEmail!
        ], replyHandler: nil, errorHandler: nil)
    }

}

extension WatchController: WCSessionDelegate {

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Activation")
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
    }

    func sessionDidDeactivate(_ session: WCSession) {
    }

}
