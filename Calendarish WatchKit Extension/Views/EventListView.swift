import SwiftUI
import CalendarishCore

struct EventListView: View {

    @ObservedObject var store: EventStore

    var body: some View {
        Group {
            if store.events.isEmpty {
                NoEventsView()
            } else {
                List(store.events) { event in
                    NavigationLink(destination: EventDetailView(event: event)) {
                        HStack {
                            Rectangle()
                                .frame(width: 5)
                                .edgesIgnoringSafeArea(.all)
                                .foregroundColor(Color(hex: event.calendar.color))
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(DateFormatter.timeFormatter.string(from: event.startTime))
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
                                    .lineLimit(3)
                                }
                                .padding()
                            }
                    }
                }
                .listStyle(CarouselListStyle())
            }
        }
    }

}

#if DEBUG
struct EventListView_Previews : PreviewProvider {
    static var previews: some View {
        EventListView(store: EventStore.sampleStore)
    }
}
#endif





