import Foundation

// MARK: - ListProvider

protocol ListProvider {
    var items: [ListItem] { get }
    
    func add(item: ListItem)
    func remove(item: ListItem)
    func clearList()
    
    func performMigrationIfRequired()
}

// MARK: - ProductionListProvider

class ProductionListProvider: ListProvider {
    
    // MARK: - Stored Properties
    
    private let userDefaults: UserDefaults
    
    // MARK: - Lifecycle
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - UserDefaultsKey
    
    struct UserDefaultsKey {
        static let items = "ListProvider.items"
        static let hasPerformedMigration = "ListProvider.hasPerformedMigration"
    }
    
    // MARK: - Items
    
    private(set) var items: [ListItem] {
        get { return userDefaults.codableValue(forKey: UserDefaultsKey.items) ?? [] }
        set { userDefaults.set(codable: newValue, forKey: UserDefaultsKey.items) }
    }

    func add(item: ListItem) {
        items.append(item)
    }
    
    func remove(item: ListItem) {
        guard let index = items.index(where: { $0.uuid == item.uuid }) else {
            print("Unable to determine index for ListItem in remove(item:)")
            return
        }
        
        items.remove(at: index)
    }
    
    func clearList() {
        items = []
    }
    
    // MARK: - Migration
    
    func performMigrationIfRequired() {
        let hasPerformedMigration = userDefaults.bool(forKey: UserDefaultsKey.hasPerformedMigration)
        guard hasPerformedMigration == false else { return }
        
        userDefaults.set(true, forKey: UserDefaultsKey.hasPerformedMigration)
        
        let previousStoredSkuList = "JFCStoredSkuListKey"
        let skuList = userDefaults.array(forKey: previousStoredSkuList) as? [String] ?? []
        
        self.items = skuList
            .flatMap({ Book.withSku($0, inContext: PersistenceService.sharedInstance.mainContext) })
            .map({ ListItem(uuid: UUID(), libraryItem: LibraryItem(title: $0.title, sku: $0.sku)) })
    }
}
