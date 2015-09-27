//
//  UserInfoService.swift
//  ExpoLivres
//
//  Created by Jeffrey Fulton on 2015-09-26.
//  Copyright © 2015 Jeffrey Fulton. All rights reserved.
//

import Foundation

class UserInfoService {
    
    static var defaults = NSUserDefaults.standardUserDefaults()
    
    static var organization: String? { return defaults.stringForKey(GlobalConstants.UserDefaultsKey.Organization) }
    static var name: String? { return defaults.stringForKey(GlobalConstants.UserDefaultsKey.Name) }
    static var email: String? { return defaults.stringForKey(GlobalConstants.UserDefaultsKey.Email) }
    
    class func isValid(organization organization: String?, name: String?, email: String?) -> Bool {
        guard let organization = organization else { return false }
        guard let name = name else { return false }
        guard let email = email else { return false }
        
        return organization.isNotEmpty && name.isNotEmpty && email.isNotEmpty && email.isEmail
    }
    
    class var isValid: Bool {
        return UserInfoService.isValid(
            organization: UserInfoService.organization,
            name: UserInfoService.name,
            email: UserInfoService.email
        )
    }
    
    class var isNotValid: Bool {
        return !self.isValid
    }
}
