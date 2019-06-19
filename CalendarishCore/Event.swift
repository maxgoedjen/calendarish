import SwiftUI

public struct Event {

    public let identifier: String
    public let name: String
    public let startTime: Date
    public let endTime: Date
    public let calendar: Calendar

    internal init(identifier: String, name: String, startTime: Date, endTime: Date, calendar: Calendar) {
        self.identifier = identifier
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.calendar = calendar
    }

}

extension Event: Identifiable {

    public var id: String {
        return identifier
    }

}
