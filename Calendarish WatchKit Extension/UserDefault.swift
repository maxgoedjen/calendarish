import Foundation

@propertyWrapper
struct UserDefault<DefaultType>: Identifiable {

    let suite: UserDefaults
    let key: String
    let description: String
    let defaultValue: DefaultType

    init(_ key: String,
         suiteName: String? = nil,
         description: String,
         defaultValue: DefaultType) {
        self.key = key
        if let suiteName = suiteName {
            suite = UserDefaults(suiteName: suiteName) ?? UserDefaults.standard
        } else {
            suite = UserDefaults.standard
        }
        self.description = description
        self.defaultValue = defaultValue
    }

    var wrappedValue: DefaultType {
        get {
            return suite.object(forKey: key) as? DefaultType ?? defaultValue
        }
        set {
            suite.set(newValue, forKey: key)
        }
    }

    var id: String {
        return key
    }

}
