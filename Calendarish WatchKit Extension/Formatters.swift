import Foundation

extension DateFormatter {

    static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .short
        return f
    }()

    static let compactTimeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .short
        f.amSymbol = ""
        f.pmSymbol = ""
        return f
    }()


}

extension DateComponentsFormatter {

    static let durationFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.hour, .minute]
        f.formattingContext = .standalone
        f.unitsStyle = .abbreviated
        return f
    }()

}
