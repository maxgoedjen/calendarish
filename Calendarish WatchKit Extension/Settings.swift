import Foundation

struct Settings {

    @UserDefault("show_only_accepted_events", description: "Show only accepted events", defaultValue: true)
    var showOnlyAcceptedEvents: Bool

    @UserDefault("lock_screen_privacy", description: "Show complication while Apple Watch is locked", defaultValue: false)
    var showOnLockScreen: Bool

    @UserDefault("idle_screen_privacy", description: "Show complication while Apple Watch screen is dimmed", defaultValue: false)
    var showOnIdleScreen: Bool

    var all: [UserDefault<Bool>] {
        return [_showOnlyAcceptedEvents, _showOnLockScreen, _showOnIdleScreen]
    }

}
