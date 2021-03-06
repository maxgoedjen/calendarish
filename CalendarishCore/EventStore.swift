import Foundation
import Combine

public class EventStore: ObservableObject {

    fileprivate let queue = DispatchQueue(label: "com.calendarish.core.eventstore.disk", qos: .userInitiated)

    @Published public var events: [Event] {
        didSet {
            saveToDisk()
        }
    }
    
    public init(events: [Event]? = nil) {
        if let events = events {
            self.events = events
        } else {
            self.events = []
            self.events = loadFromDisk()
        }
    }

}

extension EventStore {

    func saveToDisk() {
        queue.async {
            guard let data = try? JSONEncoder().encode(self.events) else { return }
            try? data.write(to: Constants.diskURL)
        }
    }

    func loadFromDisk() -> [Event] {
        var savedEvents: [Event] = []
        queue.sync {
            guard let data = try? Data(contentsOf: Constants.diskURL) else { return }
            savedEvents = (try? JSONDecoder().decode([Event].self, from: data)) ?? []
        }
        return savedEvents
    }

}

extension EventStore {

    enum Constants {
        static let diskURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("calendarish_es_cache.json")
    }

}
