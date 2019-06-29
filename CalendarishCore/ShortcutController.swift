import Combine
import Intents

public class ShortcutController {

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }

    public init() {}

    public var events: [Event] = [] {
        didSet {
            updateIntents()
        }
    }

}

extension ShortcutController {

    func updateIntents() {
        let shortcuts = events.map({ shortcut(for: $0 )})
        // TODO: REMOVE
        let test = Array(shortcuts[0..<1])
        INRelevantShortcutStore.default.setRelevantShortcuts(test, completionHandler: nil)
    }

    func shortcut(for event: Event) -> INRelevantShortcut {
        let activity = NSUserActivity(activityType: "com.calendarish.event")
        activity.title = event.name
        activity.expirationDate = event.endTime

        let base = INShortcut(userActivity: activity)
        let shortcut = INRelevantShortcut(shortcut: base)
        let card = INDefaultCardTemplate(title: event.name)
        let startString = dateFormatter.string(from: event.startTime)
        let subtitle: String
        if let location = event.location {
            subtitle = "\(startString) \(location)"
        } else {
            subtitle = startString
        }
        card.subtitle = subtitle
        shortcut.shortcutRole = .information
        shortcut.relevanceProviders = [INDateRelevanceProvider(start: event.startTime, end: event.endTime)]
        shortcut.watchTemplate = card
        return shortcut
    }

}
