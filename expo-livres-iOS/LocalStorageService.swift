//
//  LocalStorageService.swift
//  expo-livres-iOS
//
//  Created by Jeffrey Fulton on 2015-08-14.
//  Copyright (c) 2015 Jeffrey Fulton. All rights reserved.
//

import Foundation

class LocalStorageService {
    
    static let defaults = NSUserDefaults.standardUserDefaults()
    
    // MARK: - Language
    
    static var currentLanguage: Language {
        get {
            // Defaults to Language with rawValue of 0 because integerForKey returns 0 instead of nil if no value was found.
            return Language(rawValue: NSUserDefaults.standardUserDefaults().integerForKey(GlobalConstants.UserDefaultsKey.Language))!
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue.rawValue, forKey: GlobalConstants.UserDefaultsKey.Language)
            NSNotificationCenter.defaultCenter().postNotificationName(GlobalConstants.Notification.LanguageChanged, object: nil)
        }
    }
    
    // MARK: - User Info
    
    static var organization: String? {
        get { return defaults.stringForKey(GlobalConstants.UserDefaultsKey.Organization) }
        set { defaults.setObject(newValue, forKey: GlobalConstants.UserDefaultsKey.Organization) }
    }
    
    static var po: String? {
        get { return defaults.stringForKey(GlobalConstants.UserDefaultsKey.PO) }
        set { defaults.setObject(newValue, forKey: GlobalConstants.UserDefaultsKey.PO) }
    }
    
    static var name: String? {
        get { return defaults.stringForKey(GlobalConstants.UserDefaultsKey.Name) }
        set { defaults.setObject(newValue, forKey: GlobalConstants.UserDefaultsKey.Name) }
    }
    
    static var email: String? {
        get { return defaults.stringForKey(GlobalConstants.UserDefaultsKey.Email) }
        set { defaults.setObject(newValue, forKey: GlobalConstants.UserDefaultsKey.Email) }
    }
    
    // MARK: - Book List
    
    static func addToList(book: Book) {
        var tempSkuList = self.storedSkuList
        tempSkuList.append(book.sku)
        self.storedSkuList = tempSkuList
    }
    
    static func removeFromListAtIndex(index: Int) {
        var tempSkuList = self.storedSkuList
        tempSkuList.removeAtIndex(index)
        self.storedSkuList = tempSkuList
    }
    
    static func clearList() {
        self.storedSkuList = [String]()
    }
    
    static var storedSkuList: [String] {
        get { return defaults.objectForKey(GlobalConstants.UserDefaultsKey.storedSkuList) as? [String] ?? [String]() }
        set { defaults.setObject(newValue, forKey: GlobalConstants.UserDefaultsKey.storedSkuList) }
    }
}