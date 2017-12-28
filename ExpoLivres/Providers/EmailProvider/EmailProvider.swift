import Foundation

// MARK: - EmailProvider

protocol EmailProvider {
    var toRecipients: [String] { get }
    var ccRecipients: [String] { get }
    var subject: String { get }
    var body: String { get }
    
    var attachmentData: Data? { get }
    var attachmentFilename: String { get }
}

// MARK: - ProductionEmailProvider

class ProductionEmailProvider: EmailProvider {
    
    // MARK: - Stored Properties
    
    let languageProvider: LanguageProvider
    let userProvider: UserProvider
    let listProvider: ListProvider
    
    // MARK: - Lifecycle
    
    init(
        languageProvider: LanguageProvider,
        userProvider: UserProvider,
        listProvider: ListProvider)
    {
        self.languageProvider = languageProvider
        self.userProvider = userProvider
        self.listProvider = listProvider
    }
    
    // MARK: - Emails
    
    var toRecipients: [String] {
        return ["orders@boutiquedulivre.ca"]
    }
    
    var ccRecipients: [String] {
        return [userProvider.user.email]
    }
    
    // Example: EXPO-LIVRES - Organization - PO# - Name
    var subject: String {
        var subject = "EXPO-LIVRES"
        
        let user = userProvider.user
        
        if user.organization.isNotEmpty { subject += " - \(user.organization)" }
        if user.purchaseOrder.isNotEmpty { subject += " - \(user.purchaseOrder)" }
        if user.name.isNotEmpty { subject += " - \(user.name)" }
        
        return subject
    }
    
    var body: String {
        // Thank you message
        var body = "\(languageProvider.emailThankYou):\n\n"
        
        let user = userProvider.user
        
        // User info
        if user.organization.isNotEmpty {
            body += "\(languageProvider.userInfoOrganization): \(user.organization)\n"
        }
        if user.purchaseOrder.isNotEmpty {
            body += "\(languageProvider.userInfoPo): \(user.purchaseOrder)\n"
        }
        if user.name.isNotEmpty {
            body += "\(languageProvider.userInfoName): \(user.name)\n"
        }
        if user.email.isNotEmpty {
            body += "\(languageProvider.userInfoEmail): \(user.email)\n\n"
        }
        
        // Plain text booklist
        for listItem in listProvider.items {
            body += "\(listItem.libraryItem.title) - isbn: \(listItem.libraryItem.sku)\n"
        }
        
        return body
    }
    
    var attachmentData: Data? {
        var isbnString = "ISBN\n"
        
        for listItem in listProvider.items {
            isbnString += "\(listItem.libraryItem.sku)\n"
        }
       
        return isbnString.data(using: .utf8, allowLossyConversion: true)
    }
    
    // Example: Organization - PO# - Name - 2015-08-14T16:06:59
    var attachmentFilename: String {
        var fileName = ""
        
        let user = userProvider.user
        
        if user.organization.isNotEmpty { fileName += "\(user.organization)" }
        if user.purchaseOrder.isNotEmpty { fileName += " - \(user.purchaseOrder)" }
        if user.name.isNotEmpty { fileName += " - \(user.name)" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        fileName += " - \( dateFormatter.string(from: Date()) )"
        
        return fileName
    }
}
