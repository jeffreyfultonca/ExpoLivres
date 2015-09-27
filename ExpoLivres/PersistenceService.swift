//
//  PersistenceService.swift
//  ExpoLivres
//
//  Created by Jeffrey Fulton on 2015-09-27.
//  Copyright © 2015 Jeffrey Fulton. All rights reserved.
//

import CoreData

class PersistenceService {
    static let sharedInstance = PersistenceService()
    
    // MARK: - NSUserDefaults
    
    var defaults = NSUserDefaults.standardUserDefaults()
    
    struct UserDefaultsKey {
        static let Language = "JFCUserLanguagePrefsKey"
        
        static let Organization = "JFCUserOrganizationPrefsKey"
        static let PO = "JFCUserPurchaseOrderPrefsKey"
        static let Name = "JFCUserNamePrefsKey"
        static let Email = "JFCUserEmailPrefsKey"
        
        static let storedSkuList = "JFCStoredSkuListKey"
        static let checksum = "JFCChecksumKey"
    }
    
    // MARK: Language
    
    var currentLanguage: Language {
        get {
            // Defaults to Language with rawValue of 0 because integerForKey returns 0 instead of nil if no value was found.
            return Language(rawValue: defaults.integerForKey(UserDefaultsKey.Language))!
        }
        set {
            defaults.setInteger(newValue.rawValue, forKey: UserDefaultsKey.Language)
            NSNotificationCenter.defaultCenter().postNotificationName(GlobalConstants.Notification.LanguageChanged, object: nil)
        }
    }
    
    // MARK: User Info
    
    var userOrganization: String? {
        get { return defaults.stringForKey(UserDefaultsKey.Organization) }
        set { defaults.setObject(newValue, forKey:UserDefaultsKey.Organization) }
    }
    
    var userPo: String? {
        get { return defaults.stringForKey(UserDefaultsKey.PO) }
        set { defaults.setObject(newValue, forKey:UserDefaultsKey.PO) }
    }
    
    var userName: String? {
        get { return defaults.stringForKey(UserDefaultsKey.Name) }
        set { defaults.setObject(newValue, forKey:UserDefaultsKey.Name) }
    }
    
    var userEmail: String? {
        get { return defaults.stringForKey(UserDefaultsKey.Email) }
        set { defaults.setObject(newValue, forKey:UserDefaultsKey.Email) }
    }
    
    // MARK: Book List
    
    var checksum: String {
        get { return defaults.stringForKey(UserDefaultsKey.checksum) ?? "" }
        set { defaults.setObject(newValue, forKey:UserDefaultsKey.checksum) }
    }
    
    func addToList(book: Book) {
        var tempSkuList = self.storedSkuList
        tempSkuList.append(book.sku)
        self.storedSkuList = tempSkuList
    }
    
    func removeFromListAtIndex(index: Int) {
        var tempSkuList = self.storedSkuList
        tempSkuList.removeAtIndex(index)
        self.storedSkuList = tempSkuList
    }
    
    func clearList() {
        self.storedSkuList = [String]()
    }
    
    var storedSkuList: [String] {
        get { return defaults.objectForKey(UserDefaultsKey.storedSkuList) as? [String] ?? [String]() }
        set { defaults.setObject(newValue, forKey:UserDefaultsKey.storedSkuList) }
    }
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls.last!
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("expo_livres_iOS", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("expo_livres_iOS.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
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
        let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        context.name = "Main Context"
        
        return context
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving \(context.name): \(error)")
                fatalError()
            }
        }
    }
}
