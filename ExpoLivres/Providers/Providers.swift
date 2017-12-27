import Foundation

struct Providers {
    
    // MARK: - Stored Properties
    
    let languageProvider: LanguageProvider
    let migrationProvider: MigrationProvider
    
    // MARK: - Static
    
    static func forCurrentConfiguration() -> Providers {
        // These #if <Active Compilation Condition> checks will be used to run the app with appropriate providers for a given build. For instance a RELEASE build will connect to real local storage and remote networks while a TESTING build should be run will stub/mock implementations.
        
        #if TESTING
            print("******************************** Creating Testing Providers")
            return makeTestingProviders()
            
        #elseif DEBUG
            print("******************************** Creating Debug Providers")
            return makeDebugProviders()
            
        #else
            return makeReleaseProviders()
        #endif
    }
    
    // MARK: - Testing
    
    private static func makeTestingProviders() -> Providers {
        let userDefaults = UserDefaults(suiteName: UUID().uuidString)!
        
        return Providers(
            languageProvider: ProductionLanguageProvider(userDefaults: userDefaults)
        )
    }
    
    // MARK: - Debug
    
    private static func makeDebugProviders() -> Providers {
        let userDefaults = UserDefaults(suiteName: "DebugBuild")!
        
        return Providers(
            languageProvider: ProductionLanguageProvider(userDefaults: userDefaults)
        )
    }
    
    // MARK: - Release
    
    private static func makeReleaseProviders() -> Providers {
        let userDefaults = UserDefaults.standard
        
        return Providers(
            languageProvider: ProductionLanguageProvider(userDefaults: userDefaults)
        )
    }
}
