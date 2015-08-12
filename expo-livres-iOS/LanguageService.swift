//
//  LanguageService.swift
//  expo-livres-iOS
//
//  Created by Jeffrey Fulton on 2015-08-12.
//  Copyright (c) 2015 Jeffrey Fulton. All rights reserved.
//

import Foundation

class LanguageService {
    
    enum Language: Int {
        case French = 0
        case English = 1
    }
    
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
    
    // Translations
    
    class var userInfoTitle: String {
        switch currentLanguage {
        case .French:
            return "Entrez vos renseignements"
        case .English:
            return "Enter you information"
        }
    }
    
    class var userInfoOrganization: String {
        switch currentLanguage {
        case .French:
            return "Organisation"
        case .English:
            return "Organization"
        }
    }
    
    class var userInfoPo: String {
        switch currentLanguage {
        case .French:
            return "PO #"
        case .English:
            return "PO #"
        }
    }
    
    class var userInfoName: String {
        switch currentLanguage {
        case .French:
            return "Nom"
        case .English:
            return "Name"
        }
    }
    
    class var userInfoEmail: String {
        switch currentLanguage {
        case .French:
            return "Email"
        case .English:
            return "Email"
        }
    }
    
    class var required: String {
        switch currentLanguage {
        case .French:
            return "requis"
        case .English:
            return "required"
        }
    }
    
    class var optional: String {
        switch currentLanguage {
        case .French:
            return "facultatif"
        case .English:
            return "optional"
        }
    }
    
    class var listTitle: String {
        switch currentLanguage {
        case .French:
            return "Liste"
        case .English:
            return "List"
        }
    }
    
    class var listEmptyHeading: String {
        switch currentLanguage {
        case .French:
            return "Aucun livre sur la liste"
        case .English:
            return "No items in list"
        }
    }
    
    class var listBodyScan: String {
        switch currentLanguage {
        case .French:
            return "Ajouter un titre en appuyant sur le bouton du scanner en bas à droite de l\'écran"
        case .English:
            return "Add books to your list by pressing the scan button in the bottom right corner of your screen"
        }
    }
    
    class var listBodySubmit: String {
        switch currentLanguage {
        case .French:
            return "Appuyer sur Envoyer lorsque vous avez fini"
        case .English:
            return "Press submit when finished"
        }
    }
    
    class var listSwipeMessage: String {
        switch currentLanguage {
        case .French:
            return "Glisser vers la gauche pour supprimer"
        case .English:
            return "Swipe item left to remove from list"
        }
    }
    
    class var scanNotFoundTitle: String {
        switch currentLanguage {
        case .French:
            return "Oops!"
        case .English:
            return "Oops!"
        }
    }
    
    class var scanNotFoundMessage: String {
        switch currentLanguage {
        case .French:
            return "Désolés, l\'isbn {{ isbn }} n\'est pas dans notre système. Veuillez apporter votre livre à la caisse."
        case .English:
            return "We\'re sorry, isbn: {{ isbn }} not found. Please try again or bring book to front desk."
        }
    }
}