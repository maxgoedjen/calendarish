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
        return CombineLatestArray(apis.map({ $0.eventPublisher }))
            .map { $0.sorted() }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    public func reload() {
        for api in apis {
            api.reload()
        }
    }

}

private struct CombineLatestArray<PublisherType, T> : Publisher where PublisherType : Publisher, PublisherType.Output == [T] {

    typealias Output = (PublisherType.Output)
    typealias Failure = (PublisherType.Failure)

    private let combined: AnyPublisher<PublisherType.Output, PublisherType.Failure>

    init(_ publishers: [PublisherType]) {
        if publishers.isEmpty {
            combined = PassthroughSubject<PublisherType.Output, PublisherType.Failure>().eraseToAnyPublisher()
        } else if publishers.count == 1 {
            combined = publishers.first!.eraseToAnyPublisher()
        } else {
            var running = publishers.first!.eraseToAnyPublisher()
            for publisher in publishers[1...] {
                running = running.combineLatest(publisher, +).eraseToAnyPublisher()
            }
            combined = running
        }
    }

    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        combined.receive(subscriber: subscriber)
    }

}

