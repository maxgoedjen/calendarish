//
//  ContentView.swift
//  Calendarish
//
//  Created by Max Goedjen on 6/14/19.
//  Copyright © 2019 Max Goedjen. All rights reserved.
//

import SwiftUI

struct ContentView : View {

    var store: Store

    var body: some View {
        Button(action: signin) {
            if !store.isLoggedIn {
                Text("Sign In")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            } else {
                VStack {
                    Text("Signed In")
                    Image(systemName: "checkmark.seal.fill")
                }
            }
        }
    }
}

extension ContentView {

    func signin() {
        let authenticator = Authenticator(config: Constants.config)
        authenticator.authenticate()
    }

}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(store: Store())
    }
}
#endif

