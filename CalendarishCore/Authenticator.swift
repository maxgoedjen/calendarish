import Foundation
import GTMAppAuth

public struct Authenticator {

    let config: Config
    fileprivate static var runningAuthentication: OIDExternalUserAgentSession?

    public init(config: Config) {
        self.config = config
    }

    public func authenticate(from viewController: UIViewController) {
        let gtmConfig = GTMAppAuthFetcherAuthorization.configurationForGoogle()
        let request = OIDAuthorizationRequest(configuration: gtmConfig, clientId: config.clientID, clientSecret: nil, scopes: [OIDScopeOpenID, OIDScopeProfile], redirectURL: config.redirectURI, responseType: OIDResponseTypeCode, additionalParameters: nil)
        Authenticator.runningAuthentication = OIDAuthState.authState(byPresenting: request, presenting: viewController) { state, error in
            print(state as Any, error as Any)
        }
    }
}

extension Authenticator {

    public struct Config {

        let clientID: String
        let redirectURI: URL

        public init(clientID: String, redirectURI: URL) {
            self.clientID = clientID
            self.redirectURI = redirectURI
        }
    }

}

