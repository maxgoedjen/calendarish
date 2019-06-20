import Foundation
import Combine
import SwiftUI
import CalendarishCore

public class Store: BindableObject {

    public let didChange = PassthroughSubject<Void, Never>()

    public var events: [Event] = [] {
        didSet {
            didChange.send()
        }
    }
    
    public init() {
    }

}
