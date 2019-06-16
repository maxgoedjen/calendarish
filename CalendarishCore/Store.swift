import Foundation

public struct Store {

    public let authenticator: Authenticator

    public init(authenticator: Authenticator) {
        self.authenticator = authenticator
    }
    
}
