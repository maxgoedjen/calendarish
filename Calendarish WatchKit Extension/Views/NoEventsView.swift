import SwiftUI

struct NoEventsView: View {
    var body: some View {
        VStack {
            Image(systemName: "calendar")
            Text("You don't have any events soon.")
                .multilineTextAlignment(.center)
        }
    }
}

struct _Previews: PreviewProvider {
    static var previews: some View {
        NoEventsView()
    }
}
