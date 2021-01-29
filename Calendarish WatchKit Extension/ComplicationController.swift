import ClockKit
import CalendarishCore

class ComplicationController: NSObject, CLKComplicationDataSource {

    let store = EventStore()
    let settings = SettingsStore()

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        handler([
            CLKComplicationDescriptor(identifier: Complication.currentOrUpcoming.rawValue, displayName: "Current or Upcoming", supportedFamilies: CLKComplicationFamily.allCases),
            CLKComplicationDescriptor(identifier: Complication.onlyFuture.rawValue, displayName: "Future Only", supportedFamilies: CLKComplicationFamily.allCases),
        ])
    }

    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        let firstEvent = events(for: complication)
            .map({ $0.startTime })
            .first
        handler(firstEvent)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        let lastEvent = events(for: complication)
            .map({ $0.endTime })
            .last
        handler(lastEvent)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        let behavior: CLKComplicationPrivacyBehavior = settings.showOnLockScreen ? .showOnLockScreen : .hideOnLockScreen
        handler(behavior)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        let entry: CLKComplicationTimelineEntry?
        if let event = events(for: complication)
            .first {
            entry = timelineEntry(for: event, complication: complication)
        } else {
            entry = nil
        }
        handler(entry)
    }

    func getAlwaysOnTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        guard !settings.showOnIdleScreen else {
            handler(emptyTemplate(for: complication))
            return
        }
        handler(emptyTemplate(for: complication))
    }

    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        let events = self.events(for: complication).prefix(limit)
        let entries = events.compactMap({ timelineEntry(for: $0, complication: complication) })
        handler(entries)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        handler(emptyTemplate(for: complication))
    }

}

extension ComplicationController {

    func events(for complication: CLKComplication) -> [Event] {
        guard let type = Complication(rawValue: complication.identifier) else { return [] }
        switch type {
        case .currentOrUpcoming:
            return store.events
                .filter { $0.endTime > Date() }
        case .onlyFuture:
            return store.events
                .filter { $0.startTime > Date() }
        }
    }

    func template(for complication: CLKComplication, event: Event) -> CLKComplicationTemplate? {
        let nameProvider = CLKSimpleTextProvider(text: event.name)
        let timeIntervalProvider = CLKTimeIntervalTextProvider(start: event.startTime, end: event.endTime)
//        let startTimeProvider = CLKTimeTextProvider(date: event.startTime)
        let endTimeProvider = CLKTimeTextProvider(date: event.endTime)
        let durationProvider = CLKSimpleTextProvider(text: DateComponentsFormatter.durationFormatter.string(from: event.startTime, to: event.endTime) ?? "")

        switch complication.family {
        case .modularSmall:
            return nil
        case .modularLarge:
            return nil
        case .utilitarianSmall:
            return nil
        case .utilitarianSmallFlat:
            return nil
        case .utilitarianLarge:
            return nil
        case .circularSmall:
            return CLKComplicationTemplateCircularSmallRingText(textProvider: timeIntervalProvider, fillFraction: 0.5, ringStyle: .open)
        case .extraLarge:
            return nil
        case .graphicCorner:
            switch Complication(rawValue: complication.identifier) {
            case .currentOrUpcoming:
                if event.startTime < Date() {
                    let remainingGauge = CLKTimeIntervalGaugeProvider(style: .fill, gaugeColors: nil, gaugeColorLocations: nil, start: event.startTime, end: event.endTime)
                    return CLKComplicationTemplateGraphicCornerGaugeText(gaugeProvider: remainingGauge, leadingTextProvider: nil, trailingTextProvider: endTimeProvider, outerTextProvider: nameProvider)
                } else {
                    return CLKComplicationTemplateGraphicCornerStackText(innerTextProvider: nameProvider, outerTextProvider: timeIntervalProvider)
                }
            case .onlyFuture:
                return CLKComplicationTemplateGraphicCornerStackText(innerTextProvider: nameProvider, outerTextProvider: timeIntervalProvider)
            case .none:
                return nil
            }
        case .graphicBezel:
            let circular = CLKComplicationTemplateGraphicCircularStackText(line1TextProvider: CLKTimeTextProvider(date: event.startTime), line2TextProvider: durationProvider)
            return CLKComplicationTemplateGraphicBezelCircularText(circularTemplate: circular, textProvider: CLKSimpleTextProvider(text: event.name))
        case .graphicCircular:
            return CLKComplicationTemplateGraphicCircularStackText(line1TextProvider: timeIntervalProvider, line2TextProvider: nameProvider)
        case .graphicRectangular:
            return CLKComplicationTemplateGraphicRectangularStandardBody(headerTextProvider: nameProvider, body1TextProvider: timeIntervalProvider, body2TextProvider: CLKSimpleTextProvider(text: event.location ?? event.description ?? event.calendar.name))
        case .graphicExtraLarge:
            return CLKComplicationTemplateGraphicRectangularStandardBody(headerTextProvider: nameProvider, body1TextProvider: timeIntervalProvider, body2TextProvider: CLKSimpleTextProvider(text: event.location ?? event.description ?? event.calendar.name))
        @unknown default:
            return nil
        }
    }

    func timelineEntry(for event: Event, complication: CLKComplication) -> CLKComplicationTimelineEntry? {
        guard let template = template(for: complication, event: event) else {
            return nil

        }
        return CLKComplicationTimelineEntry(date: event.startTime, complicationTemplate: template)
    }

    func emptyTemplate(for complication: CLKComplication) -> CLKComplicationTemplate? {
        let unlockTextProvider = CLKSimpleTextProvider(text: "Unlock")
        let calendarTextProvider = CLKSimpleTextProvider(text: "Calendar")
        let blankTextProvider = CLKSimpleTextProvider(text: "")
        switch complication.family {
        case .modularSmall:
            return nil
        case .modularLarge:
            return nil
        case .utilitarianSmall:
            return nil
        case .utilitarianSmallFlat:
            return nil
        case .utilitarianLarge:
            return nil
        case .circularSmall:
            return CLKComplicationTemplateCircularSmallRingText(textProvider: blankTextProvider, fillFraction: 0, ringStyle: .open)
        case .extraLarge:
            return nil
        case .graphicCorner:
            return CLKComplicationTemplateGraphicCornerStackText(innerTextProvider: calendarTextProvider, outerTextProvider: unlockTextProvider)
        case .graphicBezel:
            let circular = CLKComplicationTemplateGraphicCircularStackText(line1TextProvider: blankTextProvider, line2TextProvider: blankTextProvider)
            return CLKComplicationTemplateGraphicBezelCircularText(circularTemplate: circular, textProvider: blankTextProvider)
        case .graphicCircular:
            return CLKComplicationTemplateGraphicCircularStackText(line1TextProvider: blankTextProvider, line2TextProvider: blankTextProvider)
        case .graphicRectangular:
            return CLKComplicationTemplateGraphicRectangularStandardBody(headerTextProvider: unlockTextProvider, body1TextProvider: calendarTextProvider, body2TextProvider: blankTextProvider)
        case .graphicExtraLarge:
            return CLKComplicationTemplateExtraLargeStackText(line1TextProvider: unlockTextProvider, line2TextProvider: calendarTextProvider)
        @unknown default:
            return nil
        }
    }

}

extension ComplicationController {

    private enum Complication: String {
        case currentOrUpcoming = "com.calendarish.complication.current_or_upcoming_meeting"
        case onlyFuture = "com.calendarish.complication.only_future"
    }

}
