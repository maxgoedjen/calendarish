import Foundation
import Combine
import SwiftUI

public class Store: BindableObject {

    public let didChange = PassthroughSubject<Void, Never>()

    public var events: [Event]{
        didSet {
            didChange.send()
        }
    }
    
    public init(events: [Event] = []) {
        self.events = events
    }

}
