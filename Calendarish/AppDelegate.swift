import UIKit
import SwiftUI
import Combine
import WatchConnectivity
import Sentry

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    fileprivate lazy var authorizationController: AuthorizationController = {
        let controller = AuthorizationController(targetWindow: window!)
        return controller
    }()
    let watchController = WatchController(session: WCSession.default)
    fileprivate var authorizationSubscription: AnyCancellable?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureSentry()
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = UIHostingController(rootView: ContentView(authorizationController: authorizationController))
        authorizationSubscription = authorizationController.authorizationPublisher.assertNoFailure().sink { authorization in
            self.watchController.addAuthorization(authorization: authorization)
        }
        window.makeKeyAndVisible()
        return true
    }

}

extension AppDelegate {

    func configureSentry() {
        do {
            Client.shared = try Client(dsn: "https://4cb5596c00f44edfa68a033f8ec402fc@sentry.io/156458")
            try Client.shared?.startCrashHandler()
            Client.shared?.environment = "iOS"
        } catch let error {
            print("\(error)")
        }
    }

}
