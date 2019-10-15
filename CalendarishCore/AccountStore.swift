import Foundation
import Combine
import Security

public class AccountStore: ObservableObject {

    let queue = DispatchQueue(label: "com.calendarish.core.accountstore.keychain", qos: .userInitiated)

    @Published public var accounts: [Account] {
        didSet {
            saveToKeychain()
        }
    }

    public init(accounts: [Account]? = nil) {
        if let accounts = accounts {
            self.accounts = accounts
        } else {
            self.accounts = []
            loadFromKeychain()
        }
    }

}

extension AccountStore {

    func saveToKeychain() {
        queue.async {
            guard let data = try? JSONEncoder().encode(self.accounts) else { return }
            let query: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrApplicationTag as String: Constants.keychainTag,
                kSecValueData as String: data
            ]
            let status = SecItemAdd(query as CFDictionary, nil)
            if status == errSecDuplicateItem {
                let updateQuery = [kSecValueData as String: data]
                let updateStatus = SecItemUpdate(query as CFDictionary, updateQuery as CFDictionary)
                assert(updateStatus == errSecSuccess, "Failed to save to keychain")
            } else {
                assert(status == errSecSuccess, "Failed to save to keychain")
            }
        }
    }

    func loadFromKeychain() {
        queue.async {
            let query: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrApplicationTag as String: Constants.keychainTag,
                kSecReturnData as String: true
            ]
            var item: CFTypeRef?
            let status = SecItemCopyMatching(query as CFDictionary, &item)
            assert(status == errSecSuccess || status == errSecItemNotFound, "Failed to retrieve from keychain")
            guard let data = item as? Data else { return }
            guard let savedAccounts = try? JSONDecoder().decode([Account].self, from: data) else { return }
            guard self.accounts.isEmpty else { return }
            DispatchQueue.main.async {
                self.accounts = savedAccounts
            }
        }
    }

}

extension AccountStore {

    enum Constants {
        static let keychainTag = "com.calendarish.core.accounts".data(using: .utf8)!
    }

}
