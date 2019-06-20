import WatchConnectivity
import Combine

public class SessionProxy: NSObject {

    public let contextPublisher = PassthroughSubject<[Event], Error>()
    fileprivate var session: WCSession

    public init(session: WCSession) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }

}

@available(iOS 13, *)
extension SessionProxy {

    public func send(events: [Event]) throws {
        let data = try JSONEncoder().encode(events)
        try session.updateApplicationContext([Constants.dataKey: data])
    }

}

extension SessionProxy: WCSessionDelegate {

    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Swift.Error?) {
        if let error = error {
            contextPublisher.send(completion: .failure(.sessionFailure(error)))
        }
    }

    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
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

    public func sessionDidBecomeInactive(_ session: WCSession) {
    }

    public func sessionDidDeactivate(_ session: WCSession) {

    }

}

extension SessionProxy {

    public enum Error: Swift.Error {
        case sessionFailure(Swift.Error)
        case missingData
        case invalidData
    }

    enum Constants {
        static let dataKey = "SessionProxy.data"
    }

}
