import UIKit
import AuthenticationServices
import AppAuth
import GTMAppAuth
import GoogleAPIClientForREST

class AuthorizationController: NSObject {

    let targetWindow: UIWindow
    fileprivate var running: OIDExternalUserAgentSession? = nil
    
    init(targetWindow: UIWindow) {
        self.targetWindow = targetWindow
        super.init()
    }

}

extension AuthorizationController {

    func start() {
        let gtmConfig = GTMAppAuthFetcherAuthorization.configurationForGoogle()
        let request = OIDAuthorizationRequest(configuration: gtmConfig, clientId: Constants.clientID, clientSecret: nil, scopes: [OIDScopeOpenID, OIDScopeProfile, kGTLRAuthScopeCalendarReadonly], redirectURL: Constants.redirectURI, responseType: OIDResponseTypeCode, additionalParameters: nil)
        running = OIDAuthState.authState(byPresenting: request, externalUserAgent: self) { state, error in
            guard let state = state else { return }
            let authorization = GTMAppAuthFetcherAuthorization(authState: state)
            print(authorization)
        }
    }

}

extension AuthorizationController: OIDExternalUserAgent {

    func present(_ request: OIDExternalUserAgentRequest, session: OIDExternalUserAgentSession) -> Bool {
        let authViewController = ASWebAuthenticationSession(url: request.externalUserAgentRequestURL(), callbackURLScheme: Constants.redirectURIScheme) { url, error in
            if let url = url {
                session.resumeExternalUserAgentFlow(with: url)
            } else if let error = error {
                session.failExternalUserAgentFlowWithError(error)
            }
        }
        authViewController.presentationContextProvider = self
        authViewController.start()
        return true
    }

    func dismiss(animated: Bool, completion: @escaping () -> Void) {
        // This is automatic with ASWebAuthenticationSession
        completion()
    }

}

extension AuthorizationController: ASWebAuthenticationPresentationContextProviding {

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return targetWindow
    }

}
