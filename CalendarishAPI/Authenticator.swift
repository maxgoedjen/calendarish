import Foundation
import GoogleAPIClientForREST
import GTMSessionFetcher

#if os(iOS)
import GTMAppAuth
import AppAuth
#endif

public protocol AuthenticatorProtocol {
//    var authorization: GTMFetcherAuthorizationProtocol { get }
}

public struct Authenticator {

    let config: Config

    #if os(iOS)
    fileprivate static var runningAuthentication: OIDExternalUserAgentSession?
    #endif

    public init(config: Config) {
        self.config = config
    }

}

#if os(iOS)
public protocol AuthenticatorSetupProtocol {
    func authenticate(from viewController: UIViewController)
}

extension Authenticator: AuthenticatorSetupProtocol {

    public var authorization: GTMFetcherAuthorizationProtocol? {
        return GTMAppAuthFetcherAuthorization.init(fromKeychainForName: config.clientID)
    }

    public func authenticate(from viewController: UIViewController) {
//        let gtmConfig = GTMAppAuthFetcherAuthorization.configurationForGoogle()
//        let request = OIDAuthorizationRequest(configuration: gtmConfig, clientId: config.clientID, clientSecret: nil, scopes: [OIDScopeOpenID, OIDScopeProfile, kGTLRAuthScopeCalendarReadonly], redirectURL: config.redirectURI, responseType: OIDResponseTypeCode, additionalParameters: nil)
//        OIDAuthState.authState(byPresenting: request, externalUserAgent: self) { state, error in
//            guard let state = state else { return }
//            let authorization = GTMAppAuthFetcherAuthorization(authState: state)
//            GTMAppAuthFetcherAuthorization.save(authorization, toKeychainForName: self.config.clientID)
//        }
    }

}

//extension Authenticator: OIDExternalUserAgent {
//
//    public func present(_ request: OIDExternalUserAgentRequest, session: OIDExternalUserAgentSession) -> Bool {
//        UIApplication.shared.delegate?.application?(UIApplication.shared, open: request.externalUserAgentRequestURL(), options: [:])
//        return true
//    }
//
//    public func dismiss(animated: Bool, completion: @escaping () -> Void) {
//
//    }
//
//}

#endif

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
