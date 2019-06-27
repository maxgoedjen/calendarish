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
        List {
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
                }
                .listRowBackground(Color.clear)
            ForEach(event.attendees) { attendee in
                HStack {
                    Text(attendee.name)
                    Spacer()
                    self.image(for: attendee.response)
                }
            }

            }
            .padding()
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
        EventDetailView(event: Store.sampleStore.events[2]).environment(\.colorScheme, .dark)
    }
}
#endif








