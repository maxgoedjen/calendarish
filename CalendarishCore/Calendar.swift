import Foundation

public struct Calendar: Codable, Equatable {

    public let identifier: String
    public let name: String
    public let color: String

    public init(identifier: String, name: String, color: String) {
        self.identifier = identifier
        self.name = name
        self.color = color
    }

}
