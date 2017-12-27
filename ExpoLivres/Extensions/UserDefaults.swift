import Foundation

extension UserDefaults {
    func codableValue<T: Codable>(forKey key: String) -> T? {
        guard
            let encoded = self.value(forKey: key) as? Data,
            let decoded = try? PropertyListDecoder().decode(T.self, from: encoded)
            else { return nil }
        
        return decoded
    }
    
    func set<T: Codable>(codable value: T?, forKey key: String) {
        guard let encoded = try? PropertyListEncoder().encode(value) else { return }
        self.set(encoded, forKey: key)
    }
}
