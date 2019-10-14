import ClockKit
import CalendarishCore

class ComplicationController: NSObject, CLKComplicationDataSource {

    #if DEBUG
    let store = EventStore.sampleStore
    #endif
    
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
        handler(template(for: complication))
    }

}

extension ComplicationController {

    func template(for complication: CLKComplication) -> CLKComplicationTemplate? {
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
            return nil
        case .extraLarge:
            return nil
        case .graphicCorner:
            return nil
        case .graphicBezel:
            return nil
        case .graphicCircular:
            return nil
        case .graphicRectangular:
            return nil
        @unknown default:
            return nil
        }
    }

    func timelineEntry(for event: Event, complication: CLKComplication) -> CLKComplicationTimelineEntry? {
        guard let template = template(for: complication) else { return nil }
        let timelineEntry: CLKComplicationTimelineEntry
        switch complication.family {
        default:
            timelineEntry = CLKComplicationTimelineEntry(date: event.startTime, complicationTemplate: template)
            //        case .modularSmall:
            //            timelineEntry = nil
            //        case .modularLarge:
            //            timelineEntry = nil
            //        case .utilitarianSmall:
            //            timelineEntry = nil
            //        case .utilitarianSmallFlat:
            //            timelineEntry = nil
            //        case .utilitarianLarge:
            //            timelineEntry = nil
            //        case .circularSmall:
            //            timelineEntry = nil
            //        case .extraLarge:
            //            timelineEntry = nil
            //        case .graphicCorner:
            //            timelineEntry = nil
            //        case .graphicBezel:
            //            timelineEntry = nil
            //        case .graphicCircular:
            //            timelineEntry = nil
            //        case .graphicRectangular:
            //            timelineEntry = nil
            //        @unknown default:
            //            timelineEntry = nil
        }
        return timelineEntry
    }

    func emptyEntry(for complication: CLKComplication) -> CLKComplicationTimelineEntry? {
        guard let template = template(for: complication) else { return nil }
        let timelineEntry: CLKComplicationTimelineEntry
        switch complication.family {
        default:
            timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            //        case .modularSmall:
            //            timelineEntry = nil
            //        case .modularLarge:
            //            timelineEntry = nil
            //        case .utilitarianSmall:
            //            timelineEntry = nil
            //        case .utilitarianSmallFlat:
            //            timelineEntry = nil
            //        case .utilitarianLarge:
            //            timelineEntry = nil
            //        case .circularSmall:
            //            timelineEntry = nil
            //        case .extraLarge:
            //            timelineEntry = nil
            //        case .graphicCorner:
            //            timelineEntry = nil
            //        case .graphicBezel:
            //            timelineEntry = nil
            //        case .graphicCircular:
            //            timelineEntry = nil
            //        case .graphicRectangular:
            //            timelineEntry = nil
            //        @unknown default:
            //            timelineEntry = nil
        }
        return timelineEntry
    }



}
