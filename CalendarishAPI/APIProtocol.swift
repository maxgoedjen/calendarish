import Foundation
import Combine
import CalendarishCore

public protocol APIProtocol {
    var eventPublisher: AnyPublisher<[Event], API.Error> { get }
    func reload()
}
