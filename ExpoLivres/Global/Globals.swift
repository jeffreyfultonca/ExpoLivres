import UIKit
import AVFoundation

enum AppError: Error {
    case parsingJSONAttribute(attribute: String, forEntity: String)
    case parsingJSONRootDictionary
    case parsingJSONMd5Checksum
    case parsingJSONBooks
}

struct GlobalConstants {
    static let AppName = "EXPO-LIVRES"
    static var updateLibraryURL: String {
        return "https://www.boutiquedulivre.ca/?expo-livres-books-list&md5_checksum=\(PersistenceService.sharedInstance.checksum)"
    }
    
    struct Notification {
        static let LanguageChanged = "JFCLanguageChangedNotification"
    }
    
    struct email {
        static let toRecipient = "orders@boutiquedulivre.ca"
        static var subject: String {
            // Example: EXPO-LIVRES - Organization - PO# - Name
            var subject = "\(GlobalConstants.AppName)"
            
            if let organization = PersistenceService.sharedInstance.userOrganization { subject += " - \(organization)" }
            if let po = PersistenceService.sharedInstance.userPo { subject += " - \(po)" }
            if let name = PersistenceService.sharedInstance.userName { subject += " - \(name)" }
            
            return subject
        }
        static var body: String {
            // Thank you message
            var body = "\(LanguageService.emailThankYou):\n\n"
            
            // User info
            if let organization = PersistenceService.sharedInstance.userOrganization {
                body += "\(LanguageService.userInfoOrganization): \(organization)\n"
            }
            if let po = PersistenceService.sharedInstance.userPo {
                body += "\(LanguageService.userInfoPo): \(po)\n"
            }
            if let name = PersistenceService.sharedInstance.userName {
                body += "\(LanguageService.userInfoName): \(name)\n"
            }
            if let email = PersistenceService.sharedInstance.userEmail {
                body += "\(LanguageService.userInfoEmail): \(email)\n\n"
            }
            
            // Plain text booklist
            let context = PersistenceService.sharedInstance.mainContext
            for sku in PersistenceService.sharedInstance.storedSkuList {
                if let book = Book.withSku(sku, inContext: context) {
                    body += "\(book.title) - isbn: \(book.sku)\n"
                }
            }
            
            return body
        }
        static var attachedFileName: String {
            // Example: Organization - PO# - Name - 2015-08-14T16:06:59
            var fileName = ""
            
            if let organization = PersistenceService.sharedInstance.userOrganization { fileName += "\(organization)" }
            if let po = PersistenceService.sharedInstance.userPo { fileName += " - \(po)" }
            if let name = PersistenceService.sharedInstance.userName { fileName += " - \(name)" }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            fileName += " - \( dateFormatter.string(from: Date()) )"
            
            return fileName
        }
    }
}

extension String {
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    var isEmail: Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$",
            options: NSRegularExpression.Options.caseInsensitive)
        
        return regex.numberOfMatches(in: self, options: [], range: NSMakeRange(0, self.count)) > 0
    }
}

extension UITextField {
    var isNotEmpty: Bool {
        return self.text!.isNotEmpty
    }
    
    var isEmail: Bool {
        return self.text!.isEmail
    }
}

extension AVCaptureVideoOrientation {
    static var currentDeviceOrientation: AVCaptureVideoOrientation {
        switch UIDevice.current.orientation {
        case .landscapeRight:
            return .landscapeLeft
        case .landscapeLeft:
            return .landscapeRight
        case .portrait:
            return .portrait
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
}