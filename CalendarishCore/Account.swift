import Foundation

public struct Account: Codable {

    public let email: String
    public let authorization: Data

    public init(email: String, authorization: Data) {
        self.email = email
        self.authorization = authorization
    }

}

extension Account: Identifiable {

    public var id: String {
        return email
    }

}
