import Foundation

public struct Attendee: Codable, Equatable {

    public let identifier: String
    public let name: String
    public let response: Response

    public init(identifier: String, name: String, response: Response) {
        self.identifier = identifier
        self.name = name
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
