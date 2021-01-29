import Foundation

public struct Attendee: Codable, Equatable {

    public let identifier: String
    public let name: String
    public let email: String
    public let response: Response

    public init(identifier: String, name: String, email: String, response: Response) {
        self.identifier = identifier
        self.name = name
        self.email = email
        self.response = response
    }

}

extension Attendee {

    public enum Response: String, Codable {
        case needsAction
        case declined
        case tentative
        case accepted
    }

}

extension Attendee: Identifiable {

    public var id: String {
        return identifier
    }

}
