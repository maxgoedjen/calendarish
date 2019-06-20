import SwiftUI

struct ContentView : View {

    @State var store: Store

    var body: some View {
        VStack {
            Text("Signed In")
            Image(systemName: "checkmark.seal.fill")
            List(store.events) { event in
                VStack(alignment: .leading) {
                    Text(event.name)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text(event.calendar.name)
                }
            }
        }
    }

}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(store: Store())
    }
}
#endif


