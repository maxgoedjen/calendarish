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

    @State var accountStore: AccountStore
    @State var eventStore: EventStore

    let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .short
        return f
    }()


    var body: some View {
        Group {
            if !accountStore.accounts.isEmpty {
                LoginView(accountStore: accountStore)
            } else {
                VStack {
                    LoginView(accountStore: accountStore)
                    Text("Signed In")
                    List(accountStore.accounts) { account in
                        Text(account.id)
                    }
                    Image(systemName: "checkmark.seal.fill")
                    List(eventStore.events) { event in
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

    var accountStore: AccountStore

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
    }

}

#if DEBUG
//struct ContentView_Previews : PreviewProvider {
//    static var previews: some View {
//        Group {
//            ContentView(authenticator: SampleAuthenticator(isAuthorized: true), store: EventStore.sampleStore)
//                .environment(\.colorScheme, .dark)
//            ContentView(authenticator: SampleAuthenticator(isAuthorized: true), store: EventStore.sampleStore)
//                .environment(\.colorScheme, .light)
//            ContentView(authenticator: SampleAuthenticator(isAuthorized: false), store: EventStore.sampleStore)
//                .environment(\.colorScheme, .dark)
//        }
//    }
//}
#endif

