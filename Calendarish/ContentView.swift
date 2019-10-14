import SwiftUI

struct ContentView : View {

    let authorizationController: AuthorizationController?

    init(authorizationController: AuthorizationController? = nil) {
        self.authorizationController = authorizationController
    }

    var body: some View {
                    Button(action: signin) {
                        Text("Add Account")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
}

extension ContentView {

    func signin() {
        authorizationController?.start()
    }

}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
#endif
