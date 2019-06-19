import Foundation
import Combine
import CalendarishCore

public class Store {

    let subject = PassthroughSubject<Void, Never>()

    public var events: [Event] = [] {
        didSet {
            subject.send()
        }
    }
    
    public init() {
    }

}
