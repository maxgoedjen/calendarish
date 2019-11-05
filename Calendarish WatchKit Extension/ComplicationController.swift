import ClockKit
import CalendarishCore

class ComplicationController: NSObject, CLKComplicationDataSource {

    let store = EventStore()
    let settings = Settings()

    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        let firstEvent = store.events.map({ $0.startTime }).sorted().first
        handler(firstEvent)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        let lastEvent = store.events.map({ $0.endTime }).sorted().last
        handler(lastEvent)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        let behavior: CLKComplicationPrivacyBehavior = settings.showOnLockScreen ? .showOnLockScreen : .hideOnLockScreen
        handler(behavior)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        let entry: CLKComplicationTimelineEntry?
        if let event = store.events.filter({ $0.startTime >= Date() }).first {
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
        let events = store.events.filter({ $0.startTime >= date }).prefix(limit)
        let entries = events.compactMap({ timelineEntry(for: $0, complication: complication) })
        handler(entries)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        handler(emptyTemplate(for: complication))
    }

}

extension ComplicationController {

    func template(for complication: CLKComplication, event: Event) -> CLKComplicationTemplate? {
        let nameProvider = CLKSimpleTextProvider(text: event.name)
        let timeIntervalProvider = CLKTimeIntervalTextProvider(start: event.startTime, end: event.endTime)
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
            let template = CLKComplicationTemplateCircularSmallRingText()
            template.textProvider = timeIntervalProvider
            template.ringStyle = .open
            template.fillFraction = 0.5
            return template
        case .extraLarge:
            return nil
        case .graphicCorner:
            let template = CLKComplicationTemplateGraphicCornerStackText()
            template.innerTextProvider = nameProvider
            template.outerTextProvider = timeIntervalProvider
            return template
        case .graphicBezel:
            let template = CLKComplicationTemplateGraphicBezelCircularText()
            template.textProvider = CLKSimpleTextProvider(text: event.name)
            let circular = CLKComplicationTemplateGraphicCircularStackText()
            circular.line1TextProvider = CLKTimeTextProvider(date: event.startTime)
            circular.line2TextProvider = durationProvider
            template.circularTemplate = circular
            return template
        case .graphicCircular:
            let template = CLKComplicationTemplateGraphicCircularStackText()
            template.line1TextProvider = timeIntervalProvider
            template.line2TextProvider = nameProvider
            return template
        case .graphicRectangular:
            let template = CLKComplicationTemplateGraphicRectangularStandardBody()
            template.headerTextProvider = nameProvider
            template.body1TextProvider = timeIntervalProvider
            template.body2TextProvider = CLKSimpleTextProvider(text: event.location ?? event.description ?? event.calendar.name)
            return template
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
            let template = CLKComplicationTemplateCircularSmallRingText()
            template.textProvider = blankTextProvider
            template.ringStyle = .open
            template.fillFraction = 0
            return template
        case .extraLarge:
            return nil
        case .graphicCorner:
            let template = CLKComplicationTemplateGraphicCornerStackText()
            template.innerTextProvider = calendarTextProvider
            template.outerTextProvider = unlockTextProvider
            return template
        case .graphicBezel:
            let template = CLKComplicationTemplateGraphicBezelCircularText()
            template.textProvider = blankTextProvider
            let circular = CLKComplicationTemplateGraphicCircularStackText()
            circular.line1TextProvider = blankTextProvider
            circular.line2TextProvider = blankTextProvider
            template.circularTemplate = circular
            return template
        case .graphicCircular:
            let template = CLKComplicationTemplateGraphicCircularStackText()
            template.line1TextProvider = blankTextProvider
            template.line2TextProvider = blankTextProvider
            return template
        case .graphicRectangular:
            let template = CLKComplicationTemplateGraphicRectangularStandardBody()
            template.headerTextProvider = unlockTextProvider
            template.body1TextProvider = calendarTextProvider
            template.body2TextProvider = blankTextProvider
            return template
        @unknown default:
            return nil
        }
    }



}
