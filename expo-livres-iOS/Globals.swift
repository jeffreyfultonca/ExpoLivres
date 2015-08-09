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
        
        //Change to enumeration? Perhaps not, they probably have to be String
        static let Organization = "JFCUserOrganizationPrefsKey"
        static let PO = "JFCUserPurchaseOrderPrefsKey"
        static let Name = "JFCUserNamePrefsKey"
        static let Email = "JFCUserEmailPrefsKey"
        static let Language = "JFCUserLanguagePrefsKey"
    }
}

extension String {
    var count: Int {
        return Swift.count(self)
    }
}

extension UITextField {
    var isNotEmpty: Bool {
        return !self.text.isEmpty
    }
    
    var isEmail: Bool {
        let regex = NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$",
            options: NSRegularExpressionOptions.CaseInsensitive,
            error: nil)
        
        return regex!.numberOfMatchesInString(self.text, options: nil, range: NSMakeRange(0, self.text.count)) > 0
    }
}