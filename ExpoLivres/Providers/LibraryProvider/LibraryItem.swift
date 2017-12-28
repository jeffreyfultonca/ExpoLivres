
// MARK: - LibraryItem

/// Represents a unique book in the library of known books.
struct LibraryItem: Codable {
    let title: String
    let sku: String
}

// MARK: - Hashable

extension LibraryItem: Hashable {
    var hashValue: Int { return sku.hashValue }
}

// MARK: - Equatable

extension LibraryItem: Equatable {
    static func ==(lhs: LibraryItem, rhs: LibraryItem) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
