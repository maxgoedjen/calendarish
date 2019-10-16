import Foundation
import Combine
import CalendarishCore

public class BatchAPI {

    fileprivate let apis: [API]

    public init(apis: [API]) {
        self.apis = apis
    }

}

extension BatchAPI: APIProtocol {

    public var eventPublisher: AnyPublisher<[Event], API.Error> {
        return Publishers.MergeMany(apis.map({ $0.eventPublisher })).eraseToAnyPublisher()
    }

    public func reload() {
        for api in apis {
            api.reload()
        }
    }

}
