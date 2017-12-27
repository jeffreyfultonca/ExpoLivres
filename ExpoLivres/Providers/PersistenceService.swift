import CoreData

class PersistenceService {
    static let sharedInstance = PersistenceService()
    
    // MARK: - NSUserDefaults
    
    var defaults = UserDefaults.standard
    
    struct UserDefaultsKey {
        static let Language = "JFCUserLanguagePrefsKey"
        
        static let Organization = "JFCUserOrganizationPrefsKey"
        static let PO = "JFCUserPurchaseOrderPrefsKey"
        static let Name = "JFCUserNamePrefsKey"
        static let Email = "JFCUserEmailPrefsKey"
        
        static let StoredSkuList = "JFCStoredSkuListKey"
        static let Checksum = "JFCChecksumKey"
    }
    
    // MARK: Language
    
    var currentLanguage: Language {
        get {
            // Defaults to Language with rawValue of 0 because integerForKey returns 0 instead of nil if no value was found.
            return Language(rawValue: defaults.integer(forKey: UserDefaultsKey.Language))!
        }
        set {
            defaults.set(newValue.rawValue, forKey: UserDefaultsKey.Language)
            NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConstants.Notification.LanguageChanged), object: nil)
        }
    }
    
    // MARK: User Info
    
    var userOrganization: String? {
        get { return defaults.string(forKey: UserDefaultsKey.Organization) }
        set { defaults.set(newValue, forKey:UserDefaultsKey.Organization) }
    }
    
    var userPo: String? {
        get { return defaults.string(forKey: UserDefaultsKey.PO) }
        set { defaults.set(newValue, forKey:UserDefaultsKey.PO) }
    }
    
    var userName: String? {
        get { return defaults.string(forKey: UserDefaultsKey.Name) }
        set { defaults.set(newValue, forKey:UserDefaultsKey.Name) }
    }
    
    var userEmail: String? {
        get { return defaults.string(forKey: UserDefaultsKey.Email) }
        set { defaults.set(newValue, forKey:UserDefaultsKey.Email) }
    }
    
    // MARK: Checksum
    
    var checksum: String {
        get { return defaults.string(forKey: UserDefaultsKey.Checksum) ?? "" }
        set { defaults.set(newValue, forKey:UserDefaultsKey.Checksum) }
    }
    
    // MARK: Book List
    
    var storedSkuList: [String] {
        get { return defaults.object(forKey: UserDefaultsKey.StoredSkuList) as? [String] ?? [String]() }
        set { defaults.set(newValue, forKey:UserDefaultsKey.StoredSkuList) }
    }
    
    func addToSkuList(_ sku: String) {
        var tempSkuList = self.storedSkuList
        tempSkuList.append(sku)
        self.storedSkuList = tempSkuList
    }
    
    func removeFromListAtIndex(_ index: Int) {
        var tempSkuList = self.storedSkuList
        tempSkuList.remove(at: index)
        self.storedSkuList = tempSkuList
    }
    
    func clearList() {
        self.storedSkuList = [String]()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.last!
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "expo_livres_iOS", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("expo_livres_iOS.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.name = "Main Context"
        
        return context
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.name = "Background Context"
        
        return context
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving \(String(describing: context.name)): \(error)")
                fatalError()
            }
        }
    }
}
