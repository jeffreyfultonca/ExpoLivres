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
        do {
            let encoded = try PropertyListEncoder().encode(value)
            self.set(encoded, forKey: key)
        } catch {
            print("Failed to set Codable value with error: ", error)
        }
    }
}
