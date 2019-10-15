import SwiftUI
import CalendarishCore

struct EventListView: View {

    @ObservedObject var store: EventStore

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
        List(store.events) { event in
            NavigationLink(destination: EventDetailView(event: event)) {
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
                        .lineLimit(3)
                    }
                    .padding()
                }
        }.listStyle(CarouselListStyle())
    }

}

#if DEBUG
struct EventListView_Previews : PreviewProvider {
    static var previews: some View {
        EventListView(store: EventStore.sampleStore)
    }
}
#endif





