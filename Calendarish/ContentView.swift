//
//  ContentView.swift
//  Calendarish
//
//  Created by Max Goedjen on 6/14/19.
//  Copyright © 2019 Max Goedjen. All rights reserved.
//

import SwiftUI
import CalendarishCore
import CalendarishAPI

struct ContentView : View {

    @State var authenticator: AuthenticatorProtocol
    @State var store: Store

    let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .short
        return f
    }()


    var body: some View {
        Group {
            if !authenticator.isAuthorized {
                LoginView(authenticator: authenticator)
            } else {
                VStack {
                    Text("Signed In")
                    Image(systemName: "checkmark.seal.fill")
                    List(store.events) { event in
                        VStack(alignment: .leading) {
                            Text(event.name)
                                .font(.subheadline)
                                .fontWeight(.bold)
                            Text(self.dateFormatter.string(from: event.startTime))
                        }
                    }
                }
            }
        }
    }
}

struct LoginView: View {

    @State var authenticator: AuthenticatorProtocol

    var body: some View {
        Button(action: signin) {
            Text("Sign In")
                .font(.subheadline)
                .fontWeight(.bold)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

extension LoginView {

    func signin() {
        authenticator.authenticate(from: UIApplication.shared.keyWindow!.rootViewController!)
    }

}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(authenticator: SampleAuthenticator(isAuthorized: true), store: Store.sampleStore)
                .environment(\.colorScheme, .dark)
            ContentView(authenticator: SampleAuthenticator(isAuthorized: true), store: Store.sampleStore)
                .environment(\.colorScheme, .light)
            ContentView(authenticator: SampleAuthenticator(isAuthorized: false), store: Store.sampleStore)
                .environment(\.colorScheme, .dark)
        }
    }
}
#endif

