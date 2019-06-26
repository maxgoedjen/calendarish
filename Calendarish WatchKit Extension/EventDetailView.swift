import SwiftUI
import CalendarishCoreWatch

struct EventDetailView: View {

    @State var event: Event

    let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.timeStyle = .short
        return f
    }()

    let durationFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.hour, .minute]
        f.formattingContext = .standalone
        return f
    }()

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(self.dateFormatter.string(from: event.startTime))
                Spacer()
                Text(self.durationFormatter.string(from: event.startTime, to: event.endTime)!)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            Text(event.name)
                .font(.headline)
                .fontWeight(.bold)
                .lineLimit(nil)
            Text(event.location ?? "")
                .italic()
            Text(event.description ?? "")
                .font(.footnote)
                .lineLimit(nil)
            List(event.attendees) { attendee in
                HStack {
                    Text(attendee.name)
                    Spacer()
                    self.image(for: attendee.response)
                }
            }
            }
            .padding()
        }.isScrollEnabled(true)

    func image(for response: Attendee.Response) -> Image {
        switch response {
        case .accepted:
            return Image(systemName: "checkmark.circle.fill")
        case .declined:
            return Image(systemName: "x.circle.fill")
        case .tentative:
            return Image(systemName: "questionmark.circle.fill")
        case .needsAction:
            return Image(systemName: "circle")
        }
    }

}

#if DEBUG
struct EventDetailView_Previews : PreviewProvider {
    static var previews: some View {
        EventDetailView(event:
            Event(identifier: UUID().uuidString,
                  name: "iOS Sync",
                  startTime: Date(timeIntervalSince1970: -21600),
                  endTime: Date(timeIntervalSince1970: -19800),
                  attendees: [
                    Attendee(identifier: UUID().uuidString, name: "Max Goedjen", response: .accepted),
                    Attendee(identifier: UUID().uuidString, name: "Ivan Golub", response: .accepted),
                    Attendee(identifier: UUID().uuidString, name: "Anton Udovychenko", response: .needsAction),
                    Attendee(identifier: UUID().uuidString, name: "Oleksii Gordiienko", response: .tentative),
                    Attendee(identifier: UUID().uuidString, name: "Alexander Gritzuk", response: .declined)
                ],
                  description: "Catch up on projects, go over any high priority isues for next release.",
                  location: "Blue Devils",
                  calendar: CalendarishCoreWatch.Calendar(identifier: UUID().uuidString, name: "Work"))
            ).environment(\.colorScheme, .dark)
    }
}
#endif





