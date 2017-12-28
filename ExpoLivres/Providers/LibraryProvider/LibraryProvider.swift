import Foundation

// MARK: - LibraryProvider

protocol LibraryProvider {
    func item(withSku sku: String) -> LibraryItem?
    func updateLocalCache()
    
    func performMigrationIfRequired()
}

// MARK: - ProductionLibraryProvider

class ProductionLibraryProvider: LibraryProvider {
    
    // MARK: - Stored Properties
    
    private let userDefaults: UserDefaults
    
    // MARK: - Lifecycle
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - UserDefaultsKey
    
    struct UserDefaultsKey {
        static let items = "LibraryProvider.items"
        static let checksum = "LibraryProvider.checksum"
        static let hasPerformedMigration = "LibraryProvider.hasPerformedMigration"
    }
    
    // MARK: - Books
    
    private var items: Set<LibraryItem> {
        get { return userDefaults.codableValue(forKey: UserDefaultsKey.items) ?? [] }
        set { userDefaults.set(codable: newValue, forKey: UserDefaultsKey.items) }
    }
    
    func item(withSku sku: String) -> LibraryItem? {
        return items.first(where: { $0.sku == sku })
    }
    
    // MARK: - Update Local Cache
    
    struct JSON: Decodable {
        let checksum: String
        let libraryItems: [LibraryItem]
        
        enum CodingKeys: String, CodingKey {
            case checksum = "md5_checksum"
            case libraryItems = "books"
        }
    }
    
    func updateLocalCache() {
        let url = URL(string: "https://www.boutiquedulivre.ca/?expo-livres-books-list&md5_checksum=\(checksum)")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: parseServerData)
        task.resume()
    }
    
    private func parseServerData(_ data: Data?, response: URLResponse?, error: Error?) {
        DispatchQueue.main.async {
            guard error == nil else {
                // TODO: Handle.
                print(error!)
                return
            }
            
            guard let data = data else {
                // TODO: Handle.
                print("Failed to download data from server.")
                return
            }
            
            do {
                let json = try JSONDecoder().decode(JSON.self, from: data)
                self.checksum = json.checksum
                self.items = Set(json.libraryItems)
                
            } catch {
                // The server will not return any books when the local checksum and the server checksum are the same which results in a "No value associated with key libraryItems ('books')" error. This is fine for now.
                print(error)
            }
        }
    }
    
    private var checksum: String {
        get { return userDefaults.string(forKey: UserDefaultsKey.checksum) ?? "" }
        set { userDefaults.set(newValue, forKey:UserDefaultsKey.checksum) }
    }
    
    // MARK: - Migration
    
    func performMigrationIfRequired() {
        let hasPerformedMigration = userDefaults.bool(forKey: UserDefaultsKey.hasPerformedMigration)
        guard hasPerformedMigration == false else { return }
        
        userDefaults.set(true, forKey: UserDefaultsKey.hasPerformedMigration)
        
        let items = Book.all(inContext: PersistenceService.sharedInstance.mainContext)
            .map({ LibraryItem(title: $0.title, sku: $0.sku) })
        
        self.items = Set(items)
    }
}
