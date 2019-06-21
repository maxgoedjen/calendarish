import WatchConnectivity
import Combine

public class SessionProxy: NSObject {

    public let messagePublisher = PassthroughSubject<Message, Error>()
    fileprivate var session: WCSession
    fileprivate var pendingMessages: [Message] = []

    public init(session: WCSession) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }

}

@available(iOS 13, *)
extension SessionProxy {

    public func send(message: Message) throws {
        guard session.activationState == .activated else {
            pendingMessages.append(message)
            return
        }
        switch message {
        case .requestUpdate:
            break
//            try session.updateApplicationContext([
//                Constants.messageKey: WireMessage.requestUpdate.rawValue
//                ])
        case .update(let events):
            try session.updateApplicationContext([
                Constants.messageKey: WireMessage.update.rawValue,
                Constants.dataKey: try JSONEncoder().encode(events)
                ])
        }
    }

}

extension SessionProxy: WCSessionDelegate {

    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Swift.Error?) {
        if let error = error {
            messagePublisher.send(completion: .failure(.sessionFailure(error)))
        }
        while let message = pendingMessages.first {
            _ = try? send(message: message)
            pendingMessages.removeFirst()
        }
    }

    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        guard let messageString = applicationContext[Constants.messageKey] as? String, let message = WireMessage(rawValue: messageString) else {
            messagePublisher.send(completion: .failure(.missingMessage))
            return
        }
        switch message {
        case .requestUpdate:
            handleRequestUpdate()
        case .update:
            handleUpdate(applicationContext: applicationContext)
        }
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

    func handleRequestUpdate() {
        messagePublisher.send(.requestUpdate)
    }

    func handleUpdate(applicationContext: [String : Any]) {
        guard let contextData = applicationContext[Constants.dataKey] as? Data else {
            messagePublisher.send(completion: .failure(.missingData))
            return
        }
        guard let decoded = try? JSONDecoder().decode([Event].self, from: contextData) else {
            messagePublisher.send(completion: .failure(.invalidData))
            return
        }
        messagePublisher.send(.update(decoded))
    }

}

extension SessionProxy {

    public enum Error: Swift.Error {
        case sessionFailure(Swift.Error)
        case missingMessage
        case missingData
        case invalidData
    }

    public enum Message {
        case requestUpdate
        case update([Event])

        fileprivate init(wireMessage: WireMessage, events: [Event]? = nil) {
            switch wireMessage {
            case .requestUpdate:
                self = .requestUpdate
            case .update:
                assert(events != nil)
                self = .update(events!)
            }
        }

    }

    fileprivate enum WireMessage: String, Codable {
        case requestUpdate
        case update
    }

    enum Constants {
        static let messageKey = "SessionProxy.message"
        static let dataKey = "SessionProxy.data"
    }

}

