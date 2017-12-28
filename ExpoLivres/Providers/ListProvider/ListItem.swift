import Foundation

// MARK: - ListItem

/// Represents a unique scanned book in a user's list. Multiple ListItems can reference a single unique Library item.
struct ListItem: Codable {
    let uuid: UUID
    let libraryItem: LibraryItem
}

// MARK: - Hashable

extension ListItem: Hashable {
    var hashValue: Int { return uuid.hashValue }
}

// MARK: - Equatable

extension ListItem: Equatable {
    static func ==(lhs: ListItem, rhs: ListItem) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
