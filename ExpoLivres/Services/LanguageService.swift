//
//  LanguageService.swift
//  expo-livres-iOS
//
//  Created by Jeffrey Fulton on 2015-08-12.
//  Copyright (c) 2015 Jeffrey Fulton. All rights reserved.
//

import Foundation

enum Language: Int {
    case french = 0
    case english = 1
}

class LanguageService {
    
    static var currentLanguage: Language {
        get { return PersistenceService.sharedInstance.currentLanguage }
        set { PersistenceService.sharedInstance.currentLanguage = newValue }
    }
    
    // Translations
    
    
    // MARK: - UserInfo
    
    class var userInfoTitle: String {
        switch currentLanguage {
        case .french:
            return "Entrez vos renseignements"
        case .english:
            return "Enter your information"
        }
    }
    
    class var userInfoOrganization: String {
        switch currentLanguage {
        case .french:
            return "Organisation"
        case .english:
            return "Organization"
        }
    }
    
    class var userInfoPo: String {
        switch currentLanguage {
        case .french:
            return "PO #"
        case .english:
            return "PO #"
        }
    }
    
    class var userInfoName: String {
        switch currentLanguage {
        case .french:
            return "Nom"
        case .english:
            return "Name"
        }
    }
    
    class var userInfoEmail: String {
        switch currentLanguage {
        case .french:
            return "Email"
        case .english:
            return "Email"
        }
    }
    
    class var required: String {
        switch currentLanguage {
        case .french:
            return "requis"
        case .english:
            return "required"
        }
    }
    
    class var optional: String {
        switch currentLanguage {
        case .french:
            return "facultatif"
        case .english:
            return "optional"
        }
    }
    
    // MARK: - ListView
    
    class var listTitle: String {
        switch currentLanguage {
        case .french:
            return "Liste"
        case .english:
            return "List"
        }
    }
    
    class var listEmptyHeading: String {
        switch currentLanguage {
        case .french:
            return "Aucun livre sur la liste"
        case .english:
            return "No items in list"
        }
    }
    
    class var listBodyScan: String {
        switch currentLanguage {
        case .french:
            return "Ajouter un titre en appuyant sur le bouton du scanner en bas à droite de l\'écran"
        case .english:
            return "Add books to your list by pressing the scan button in the bottom right corner of your screen"
        }
    }
    
    class var listBodySubmit: String {
        switch currentLanguage {
        case .french:
            return "Appuyer sur Envoyer lorsque vous avez fini"
        case .english:
            return "Press submit when finished"
        }
    }
    
    class var listSwipeMessage: String {
        switch currentLanguage {
        case .french:
            return "Glisser vers la gauche pour supprimer"
        case .english:
            return "Swipe item left to remove from list"
        }
    }
    
    // MARK: - Scan
    
    class var scanNotFoundTitle: String {
        switch currentLanguage {
        case .french:
            return "Oops!"
        case .english:
            return "Oops!"
        }
    }
    
    class func scanNotFoundMessage(_ isbn: String) -> String {
        switch currentLanguage {
        case .french:
            return "Désolés, l\'isbn \(isbn) n\'est pas dans notre système. Veuillez apporter votre livre à la caisse."
        case .english:
            return "We\'re sorry, isbn: \(isbn) not found. Please try again or bring book to front desk."
        }
    }
    
    // MARK: - Email
    
    class var emailNotConfiguredTitle: String {
        switch currentLanguage {
        case .french:
            return "Oops!"
        case .english:
            return "Oops!"
        }
    }
    
    class var emailNotConfiguredMessage: String {
        switch currentLanguage {
        case .french:
            return "Une adresse courriel en vigueur sur votre appareil est requise pour soumettre votre commande."
        case .english:
            return "Email is required to submit your order. Please setup email on your device."
        }
    }
    
    class var emailThankYou: String {
        switch currentLanguage {
        case .french:
            return "Merci pour votre commande"
        case .english:
            return "Thank you for your order"
        }
    }
    
    // MARK: - Submission
    
    class var postSubmissionTitle: String {
        switch currentLanguage {
        case .french:
            return "Merci!"
        case .english:
            return "Thank you!"
        }
    }
    
    class var postSubmissionMessage: String {
        switch currentLanguage {
        case .french:
            return "Votre commande a été soumise. Passez à la caisse pour confirmer votre commande."
        case .english:
            return "Your list has been sent. Proceed to the front desk for confirmation."
        }
    }
    
    class var clearAction: String {
        switch currentLanguage {
        case .french:
            return "Supprimer liste"
        case .english:
            return "Clear list"
        }
    }
    
    class var keepAction: String {
        switch currentLanguage {
        case .french:
            return "Garder liste"
        case .english:
            return "Keep list"
        }
    }
    
    class var save: String {
        switch currentLanguage {
        case .french:
            return "OK"
        case .english:
            return "OK"
        }
    }
    
    class var addAnyway: String {
        switch currentLanguage {
        case .french:
            return "Ajouter quand même"
        case .english:
            return "Add anyway"
        }
    }
    
    class var remove: String {
        switch currentLanguage {
        case .french:
            return "Supprimer"
        case .english:
            return "Remove"
        }
    }

    class var submit: String {
        switch currentLanguage {
        case .french:
            return "Envoyer"
        case .english:
            return "Submit"
        }
    }
    
    class var scan: String {
        switch currentLanguage {
        case .french:
            return "Scan"
        case .english:
            return "Scan"
        }
    }
    
    class var language: String {
        switch currentLanguage {
        case .french:
            return "Langue"
        case .english:
            return "Language"
        }
    }
    
    class var cancel: String {
        switch currentLanguage {
        case .french:
            return "Annuler"
        case .english:
            return "Cancel"
        }
    }
    
    class var unknown: String {
        switch currentLanguage {
        case .french:
            return "Inconnu"
        case .english:
            return "Unknown"
        }
    }
}
