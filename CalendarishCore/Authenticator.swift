import Foundation

public struct Authenticator {

    let config: Config

    public init(config: Config) {
        self.config = config
    }

    public func authenticate() {
        let gtmConfig = GTMAppAuthFetcherAuthorization.configurationForGoogle()
        let request = OIDAuthorizationRequest(configuration: gtmConfig, clientId: config.clientID, clientSecret: nil, scopes: [], redirectURL: config.redirectURI, responseType: "code", additionalParameters: nil)

    }
}

public extension Authenticator {

    public struct Config {

        let clientID: String
        let redirectURI: URL

        public init(clientID: String, redirectURI: URL) {
            self.clientID = clientID
            self.redirectURI = redirectURI
        }
    }

}

