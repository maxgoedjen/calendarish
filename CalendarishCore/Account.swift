import Foundation

public struct Account: Codable {

    public let id: String
    public let email: String

}

extension Account: Identifiable {
}
