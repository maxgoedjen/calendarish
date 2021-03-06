import Foundation

public struct Event: Codable {

    public let identifier: String

    public let name: String
    public let startTime: Date
    public let endTime: Date
    public let attendees: [Attendee]
    public let description: String?
    public let location: String?

    public let calendar: Calendar

    public init(identifier: String, name: String, startTime: Date, endTime: Date, attendees: [Attendee], description: String?, location: String?, calendar: Calendar) {
        self.identifier = identifier
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.attendees = attendees
        self.description = description
        self.location = location
        self.calendar = calendar
    }

}

extension Event: Comparable {

    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.startTime < rhs.startTime
    }

}

extension Event: Identifiable {

    public var id: String {
        return identifier
    }

}
