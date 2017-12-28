import Foundation

// MARK: - User

struct User: Codable {
    let organization: String
    let purchaseOrder: String
    let name: String
    let email: String
    
    var isValid: Bool {
        return organization.isNotEmpty
            && name.isNotEmpty
            && email.isNotEmpty
            && email.isEmail
    }
}

extension User {
    init() {
        self.organization = ""
        self.purchaseOrder = ""
        self.name = ""
        self.email = ""
    }
}

// MARK: - UserProvider

protocol UserProvider {
    var user: User { get }
    func set(user: User)
    
    func performMigrationIfRequired()
}

// MARK: - ProductionUserProvider

class ProductionUserProvider: UserProvider {
    
    // MARK: - Stored Properties
    
    private let userDefaults: UserDefaults
    
    // MARK: - Lifecycle
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - UserDefaultsKey
    
    struct UserDefaultsKey {
        static let user = "UserProvider.user"
        static let hasPerformedMigration = "UserProvider.hasPerformedMigration"
    }
    
    // MARK: - User
    
    private(set) var user: User {
        get { return userDefaults.codableValue(forKey: UserDefaultsKey.user) ?? User() }
        set { userDefaults.set(codable: newValue, forKey: UserDefaultsKey.user) }
    }
    
    func set(user: User) {
        self.user = user
    }
    
    // MARK: - Migration
    
    func performMigrationIfRequired() {
        let hasPerformedMigration = userDefaults.bool(forKey: UserDefaultsKey.hasPerformedMigration)
        guard hasPerformedMigration == false else { return }

        userDefaults.set(true, forKey: UserDefaultsKey.hasPerformedMigration)
        
        let previousOrganizationKey = "JFCUserOrganizationPrefsKey"
        let previousPurchaseOrderKey = "JFCUserPurchaseOrderPrefsKey"
        let previousNameKey = "JFCUserNamePrefsKey"
        let previousEmailKey = "JFCUserEmailPrefsKey"
        
        let organization = userDefaults.string(forKey: previousOrganizationKey)
        let purchaseOrder = userDefaults.string(forKey: previousPurchaseOrderKey)
        let name = userDefaults.string(forKey: previousNameKey)
        let email = userDefaults.string(forKey: previousEmailKey)
        
        self.user = User(
            organization: organization ?? "",
            purchaseOrder: purchaseOrder ?? "",
            name: name ?? "",
            email: email ?? ""
        )
    }
}
