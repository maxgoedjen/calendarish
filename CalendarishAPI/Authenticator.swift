#if os(iOS)
import Foundation
import GoogleAPIClientForREST
import AppAuth
import GTMAppAuth

public protocol AuthenticatorProtocol {
    var isAuthorized: Bool { get }
    func authenticate(from viewController: UIViewController)
}

public struct Authenticator {

    let config: Config
    fileprivate static var runningAuthentication: OIDExternalUserAgentSession?

    public init(config: Config) {
        self.config = config
    }

}

extension Authenticator: AuthenticatorProtocol {

    public var authorization: GTMAppAuthFetcherAuthorization? {
        return GTMAppAuthFetcherAuthorization.init(fromKeychainForName: config.clientID)
    }

    public var isAuthorized: Bool {
        guard let authorization = authorization else { return false }
        return authorization.authState.isAuthorized
    }

    public func authenticate(from viewController: UIViewController) {
        let gtmConfig = GTMAppAuthFetcherAuthorization.configurationForGoogle()
        let request = OIDAuthorizationRequest(configuration: gtmConfig, clientId: config.clientID, clientSecret: nil, scopes: [OIDScopeOpenID, OIDScopeProfile, kGTLRAuthScopeCalendarReadonly], redirectURL: config.redirectURI, responseType: OIDResponseTypeCode, additionalParameters: nil)
        OIDAuthState.authState(byPresenting: request, externalUserAgent: self) { state, error in
            guard let state = state else { return }
            let authorization = GTMAppAuthFetcherAuthorization(authState: state)
            GTMAppAuthFetcherAuthorization.save(authorization, toKeychainForName: self.config.clientID)
        }
    }

}

extension Authenticator: OIDExternalUserAgent {

    public func present(_ request: OIDExternalUserAgentRequest, session: OIDExternalUserAgentSession) -> Bool {
        UIApplication.shared.delegate?.application?(UIApplication.shared, open: request.externalUserAgentRequestURL(), options: [:])
        return true
    }

    public func dismiss(animated: Bool, completion: @escaping () -> Void) {

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

#endif
