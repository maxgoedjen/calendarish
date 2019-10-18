import SwiftUI

struct ConnectPromptView: View {
    var body: some View {
        VStack {
            Image(systemName: "calendar.badge.plus")
            Text("Add an account on your iPhone to get started.")
                .multilineTextAlignment(.center)
        }
    }
}

struct ConnectPromptView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectPromptView()
    }
}
