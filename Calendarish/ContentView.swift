import SwiftUI
import GTMAppAuth
import GoogleAPIClientForREST
import AppAuth

struct ContentView : View {

    let userAgent: OIDExternalUserAgent?

    init(userAgent: OIDExternalUserAgent? = nil) {
        self.userAgent = userAgent
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
        guard let userAgent = userAgent else { return }
        let gtmConfig = GTMAppAuthFetcherAuthorization.configurationForGoogle()
        let request = OIDAuthorizationRequest(configuration: gtmConfig, clientId: Constants.clientID, clientSecret: nil, scopes: [OIDScopeOpenID, OIDScopeProfile, kGTLRAuthScopeCalendarReadonly], redirectURL: Constants.redirectURI, responseType: OIDResponseTypeCode, additionalParameters: nil)
        AuthState.runningAuthentication = OIDAuthState.authState(byPresenting: request, externalUserAgent: userAgent) { state, error in
            guard let state = state else { return }
            let authorization = GTMAppAuthFetcherAuthorization(authState: state)
            print(authorization)
        }
    }

}

fileprivate struct AuthState {
    static var runningAuthentication: OIDExternalUserAgentSession? = nil
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
