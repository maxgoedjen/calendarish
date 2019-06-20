import WatchConnectivity
import Combine

class SessionProxy: NSObject {

    public let contextPublisher = PassthroughSubject<[Event], Error>()

    public init(session: WCSession) {
        super.init()
        session.delegate = self
    }



}

extension SessionProxy: WCSessionDelegate {

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Swift.Error?) {
        if let error = error {
            contextPublisher.send(completion: .failure(.sessionFailure(error)))
        }
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        guard let contextData = applicationContext[Constants.dataKey] as? Data else {
            contextPublisher.send(completion: .failure(.missingData))
            return
        }
        guard let decoded = try? JSONDecoder().decode([Event].self, from: contextData) else {
            contextPublisher.send(completion: .failure(.invalidData))
            return
        }
        contextPublisher.send(decoded)
    }

}

@available(iOS 13, *)
extension SessionProxy {

    func sessionDidBecomeInactive(_ session: WCSession) {

    }

    func sessionDidDeactivate(_ session: WCSession) {

    }

}

extension SessionProxy {

    enum Error: Swift.Error {
        case sessionFailure(Swift.Error)
        case missingData
        case invalidData
    }

    enum Constants {
        static let dataKey = "SessionProxy.data"
    }

}
