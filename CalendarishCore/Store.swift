import Foundation
import Combine
import SwiftUI

public class Store: BindableObject {

    public let didChange = PassthroughSubject<[Event], Never>()
    let queue = DispatchQueue(label: "calendarishcore.store.disk", qos: .userInitiated)

    public var events: [Event] {
        didSet {
            didChange.send(events)
            saveToDisk()
        }
    }
    
    public init(events: [Event]? = nil) {
        if let events = events {
            self.events = events
        } else {
            self.events = []
            loadFromDisk()
        }
    }

}

extension Store {

    func saveToDisk() {
        queue.async {
            guard let data = try? JSONEncoder().encode(self.events) else { return }
            try? data.write(to: Constants.diskURL)
        }
    }

    func loadFromDisk() {
        queue.async {
            guard let data = try? Data(contentsOf: Constants.diskURL) else { return }
            guard let savedEvents = try? JSONDecoder().decode([Event].self, from: data) else { return }
            DispatchQueue.main.async {
                guard self.events.isEmpty else { return }
                self.events = savedEvents
            }
        }
    }

}

extension Store {

    enum Constants {
        static let diskURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("calendarish_cache.json")
    }

}
