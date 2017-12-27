import Foundation

// MARK: - MigrationProvider

class MigrationProvider {
    
    // MARK: - Stored Properties
    
    private let userDefaults: UserDefaults
    private let languageProvider: LanguageProvider
    
    // MARK: - Lifecycle
    
    init(
        userDefaults: UserDefaults,
        languageProvider: LanguageProvider)
    {
        self.userDefaults = userDefaults
        self.languageProvider = languageProvider
    }
    
    // MARK: - UserDefaultsKey
    
    struct UserDefaultsKey {
        static let migrationHasBeenPerformed = "MigrationProvider.migrationHasBeenPerformed"
    }

    // MARK: - Migration
    
    func performMigrationIfRequired() {
        languageProvider.performMigrationIfRequired()
    }
}
