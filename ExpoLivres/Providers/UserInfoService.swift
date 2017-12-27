import Foundation

class UserInfoService {
    
    static var persistenceService = PersistenceService.sharedInstance
    
    class var isValid: Bool {
        guard let organization = persistenceService.userOrganization else { return false }
        guard let name = persistenceService.userName else { return false }
        guard let email = persistenceService.userEmail else { return false }
        
        return organization.isNotEmpty && name.isNotEmpty && email.isNotEmpty && email.isEmail
    }
    
    class var isNotValid: Bool {
        return !self.isValid
    }
}
