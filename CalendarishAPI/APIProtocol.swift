import Foundation
import Combine
import CalendarishCore

protocol APIProtocol {
    var eventPublisher: AnyPublisher<[Event], API.Error> { get }
    func reload()
}
