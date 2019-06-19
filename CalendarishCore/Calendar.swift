import SwiftUI

public struct Calendar {

    public let identifier: String
    public let name: String
    public let color: Color

    public init(identifier: String, name: String, color: Color) {
        self.identifier = identifier
        self.name = name
        self.color = color
    }

}
