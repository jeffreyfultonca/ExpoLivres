//
//  Globals.swift
//  expo-livres-iOS
//
//  Created by Jeffrey Fulton on 2015-08-08.
//  Copyright (c) 2015 Jeffrey Fulton. All rights reserved.
//

import UIKit
import AVFoundation

struct GlobalConstants {
    static let AppName = "EXPO-LIVRES 2015"
    static var updateLibraryURL: String {
        return "http://boutiquedulivre.ca/?expo-livres-books-list&md5_checksum=\(LocalStorageService.checksum)"
    }
    
    struct UserDefaultsKey {
        static let Language = "JFCUserLanguagePrefsKey"
        
        static let Organization = "JFCUserOrganizationPrefsKey"
        static let PO = "JFCUserPurchaseOrderPrefsKey"
        static let Name = "JFCUserNamePrefsKey"
        static let Email = "JFCUserEmailPrefsKey"
        
        static let storedSkuList = "JFCStoredSkuListKey"
        static let checksum = "JFCChecksumKey"
    }
    
    struct Notification {
        static let LanguageChanged = "JFCLanguageChangedNotification"
    }
    
    struct email {
        static let toRecipient = "orders@boutiquedulivre.ca"
        static var subject: String {
            // Example: EXPO-LIVRES 2015 - Organization - PO# - Name
            var subject = "\(GlobalConstants.AppName)"
            
            if let organization = LocalStorageService.organization { subject += " - \(organization)" }
            if let po = LocalStorageService.po { subject += " - \(po)" }
            if let name = LocalStorageService.name { subject += " - \(name)" }
            
            return subject
        }
        static var body: String {
            // Thank you message
            var body = "\(LanguageService.emailThankYou):\n\n"
            
            // User info
            if let organization = LocalStorageService.organization {
                body += "\(LanguageService.userInfoOrganization): \(organization)\n"
            }
            if let po = LocalStorageService.po {
                body += "\(LanguageService.userInfoPo): \(po)\n"
            }
            if let name = LocalStorageService.name {
                body += "\(LanguageService.userInfoName): \(name)\n"
            }
            if let email = LocalStorageService.email {
                body += "\(LanguageService.userInfoEmail): \(email)\n\n"
            }
            
            // Plain text booklist
            for sku in LocalStorageService.storedSkuList {
                
                if let book = LibraryService.bookWithSku(sku) {
                    body += "\(book.title) - isbn: \(book.sku)\n"
                }
            }
            
            return body
        }
        static var attachedFileName: String {
            // Example: Organization - PO# - Name - 2015-08-14T16:06:59
            var fileName = ""
            
            if let organization = LocalStorageService.organization { fileName += "\(organization)" }
            if let po = LocalStorageService.po { fileName += " - \(po)" }
            if let name = LocalStorageService.name { fileName += " - \(name)" }
            
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            fileName += " - \( dateFormatter.stringFromDate(NSDate()) )"
            
            return fileName
        }
    }
}

extension String {
    var count: Int {
        return Swift.count(self)
    }
    
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    var isEmail: Bool {
        let regex = NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$",
            options: NSRegularExpressionOptions.CaseInsensitive,
            error: nil)
        
        return regex!.numberOfMatchesInString(self, options: nil, range: NSMakeRange(0, self.count)) > 0
    }
}

extension UITextField {
    var isNotEmpty: Bool {
        return self.text.isNotEmpty
    }
    
    var isEmail: Bool {
        return self.text.isEmail
    }
}

extension AVCaptureVideoOrientation {
    static var currentDeviceOrientation: AVCaptureVideoOrientation {
        switch UIDevice.currentDevice().orientation {
        case .LandscapeRight:
            return .LandscapeLeft
        case .LandscapeLeft:
            return .LandscapeRight
        case .Portrait:
            return .Portrait
        case .PortraitUpsideDown:
            return .PortraitUpsideDown
        default:
            return .Portrait
        }
    }
}