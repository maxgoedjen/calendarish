import ClockKit
import CalendarishCore

class ComplicationController: NSObject, CLKComplicationDataSource {

    let store = EventStore()

    let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .short
        return f
    }()

    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        let firstEvent = store.events.first?.startTime
        handler(firstEvent)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        let firstEvent = store.events.last?.endTime
        handler(firstEvent)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.hideOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        let entry: CLKComplicationTimelineEntry?
        if let event = store.events.filter({ $0.startTime > Date() }).first {
            entry = timelineEntry(for: event, complication: complication)
        } else {
            entry = emptyEntry(for: complication)
        }
        handler(entry)
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        let events = store.events.filter({ $0.startTime < date }).prefix(limit)
        let entries = events.compactMap({ timelineEntry(for: $0, complication: complication) })
        handler(entries)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        let events = store.events.filter({ $0.startTime > date }).prefix(limit)
        let entries = events.compactMap({ timelineEntry(for: $0, complication: complication) })
        handler(entries)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        handler(emptyEntry(for: complication)?.complicationTemplate)
    }

}

extension ComplicationController {

    func template(for complication: CLKComplication, event: Event) -> CLKComplicationTemplate? {
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
            let template = CLKComplicationTemplateCircularSmallStackText()
            template.line1TextProvider = CLKTextProvider(format: dateFormatter.string(from: event.startTime))
            template.line2TextProvider = CLKTextProvider(format: "--")
            return template
        case .extraLarge:
            return nil
        case .graphicCorner:
            return nil
        case .graphicBezel:
            return nil
        case .graphicCircular:
            let template = CLKComplicationTemplateGraphicCircularStackText()
            template.line1TextProvider = CLKTextProvider(format: "--")
            template.line2TextProvider = CLKTextProvider(format: "--")
            return template
        case .graphicRectangular:
            return nil
        @unknown default:
            return nil
        }
    }

    func timelineEntry(for event: Event, complication: CLKComplication) -> CLKComplicationTimelineEntry? {
        guard let template = template(for: complication, event: event) else { return nil }
        return CLKComplicationTimelineEntry(date: event.startTime, complicationTemplate: template)
    }

    func emptyEntry(for complication: CLKComplication) -> CLKComplicationTimelineEntry? {
        let calendar = CalendarishCore.Calendar(identifier: UUID().uuidString, name: "Calendar")
        let event = Event(identifier: UUID().uuidString, name: "Event", startTime: Date.distantPast, endTime: Date.distantFuture, attendees: [], description: nil, location: nil, calendar: calendar)
        guard let template = template(for: complication, event: event) else { return nil }
        return CLKComplicationTimelineEntry(date: event.startTime, complicationTemplate: template)
    }



}
