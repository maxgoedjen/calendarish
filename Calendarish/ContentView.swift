//
//  ContentView.swift
//  Calendarish
//
//  Created by Max Goedjen on 6/14/19.
//  Copyright © 2019 Max Goedjen. All rights reserved.
//

import SwiftUI
import CalendarishCore

struct ContentView : View {

    @State var store: Store

    var body: some View {
        Group {
            if !store.authenticator.isAuthorized {
                Button(action: signin) {
                    Text("Sign In")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            } else {
                VStack {
                    Text("Signed In")
                    Image(systemName: "checkmark.seal.fill")
                    List(store.events) { event in
                        VStack {
                            Text(event.name)
                                .font(.subheadline)
                                .fontWeight(.bold)
                            Text(event.calendar.name)
                        }
                    }
                }
            }
        }
    }
}

extension ContentView {

    func signin() {
        store.authenticator.authenticate(from: UIApplication.shared.keyWindow!.rootViewController!)
    }

}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(authenticator: Authenticator(config: Constants.config)))
    }
}
#endif

