import SwiftUI
import CalendarishCore

struct EventDetailView: View {

    @State var event: Event

    var body: some View {
        List {
            EventDescriptionView(event: event)
            EventAttendeeListView(attendees: event.attendees)
        }
            .padding()
    }

}

struct EventDescriptionView: View {

    let event: Event

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(DateFormatter.dateFormatter.string(from: event.startTime))
                Spacer()
                Text(DateComponentsFormatter.durationFormatter.string(from: event.startTime, to: event.endTime)!)
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
            }
            .listRowBackground(Color.clear)
    }

}

struct EventAttendeeListView: View {

    let attendees: [Attendee]

    var body: some View {
        ForEach(attendees) { attendee in
            HStack {
                Text(attendee.name)
                Spacer()
                self.image(for: attendee.response)
            }
        }
    }

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
        ForEach(EventStore.sampleStore.events) { event in
            EventDetailView(event: event)
        }.environment(\.colorScheme, .dark)
    }
}
#endif
