import Combine
import Intents

class ShortcutController {

    var events: [Event] = [] {
        didSet {
            updateIntents()
        }
    }

}

extension ShortcutController {

    func updateIntents() {
        let shortcuts = events.map({ shortcut(for: $0 )})
        print(shortcuts)
    }

    func shortcut(for event: Event) -> INShortcut {
        fatalError()
//        let intent = INIntent()
//        intent.identifier = event.identifier
//        intent.intentDescription = event.description
//        guard let shortcut = INShortcut(intent: intent) else { return nil }
//
//        let suggestedShortcut = INRelevantShortcut(shortcut: shortcut)
//
//        let localizedTitle = NSString.deferredLocalizedIntentsString(with: event.name) as String
//        let template = INDefaultCardTemplate(title: localizedTitle)
//        template.subtitle =
////        template.image = INImage(syste)
//
//        suggestedShortcut.watchTemplate = template
//        return suggestedShortcut
    }

}
