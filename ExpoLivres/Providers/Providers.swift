import Foundation

struct Providers {
    
    // MARK: - Stored Properties
    
    let languageProvider: LanguageProvider
    let userProvider: UserProvider
    let listProvider: ListProvider
    let libraryProvider: LibraryProvider
    let emailProvider: EmailProvider
    
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
        
        let languageProvider = ProductionLanguageProvider(userDefaults: userDefaults)
        let userProvider = ProductionUserProvider(userDefaults: userDefaults)
        let listProvider = ProductionListProvider(userDefaults: userDefaults)
        
        return Providers(
            languageProvider: languageProvider,
            userProvider: userProvider,
            listProvider: listProvider,
            libraryProvider: ProductionLibraryProvider(userDefaults: userDefaults),
            emailProvider: ProductionEmailProvider(
                languageProvider: languageProvider,
                userProvider: userProvider,
                listProvider: listProvider
            )
        )
    }
    
    // MARK: - Debug
    
    private static func makeDebugProviders() -> Providers {
        let userDefaults = UserDefaults(suiteName: "DebugBuild")!
        
        let languageProvider = ProductionLanguageProvider(userDefaults: userDefaults)
        let userProvider = ProductionUserProvider(userDefaults: userDefaults)
        let listProvider = ProductionListProvider(userDefaults: userDefaults)
        
        return Providers(
            languageProvider: languageProvider,
            userProvider: userProvider,
            listProvider: listProvider,
            libraryProvider: ProductionLibraryProvider(userDefaults: userDefaults),
            emailProvider: ProductionEmailProvider(
                languageProvider: languageProvider,
                userProvider: userProvider,
                listProvider: listProvider
            )
        )
    }
    
    // MARK: - Release
    
    private static func makeReleaseProviders() -> Providers {
        let userDefaults = UserDefaults.standard
        
        let languageProvider = ProductionLanguageProvider(userDefaults: userDefaults)
        let userProvider = ProductionUserProvider(userDefaults: userDefaults)
        let listProvider = ProductionListProvider(userDefaults: userDefaults)
        
        return Providers(
            languageProvider: languageProvider,
            userProvider: userProvider,
            listProvider: listProvider,
            libraryProvider: ProductionLibraryProvider(userDefaults: userDefaults),
            emailProvider: ProductionEmailProvider(
                languageProvider: languageProvider,
                userProvider: userProvider,
                listProvider: listProvider
            )
        )
    }
}
