//
//  Globals.swift
//  expo-livres-iOS
//
//  Created by Jeffrey Fulton on 2015-08-08.
//  Copyright (c) 2015 Jeffrey Fulton. All rights reserved.
//

import UIKit

struct GlobalConstants {
    struct UserDefaultsKey {
        
        //Change to enumeration?
        static let Language = "JFCUserLanguagePrefsKey"
        static let Organization = "JFCUserOrganizationPrefsKey"
        static let PO = "JFCUserPurchaseOrderPrefsKey"
        static let Name = "JFCUserNamePrefsKey"
        static let Email = "JFCUserEmailPrefsKey"
    }
    
    struct Notification {
        static let LanguageChanged = "JFCLanguageChangedNotification"
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