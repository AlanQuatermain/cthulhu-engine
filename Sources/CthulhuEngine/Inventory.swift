import Foundation

/// A single inventory item tracked on a character sheet.
public struct Item: Codable, Hashable, Sendable {
    public var name: String
    public var quantity: Int
    public var notes: String?

    public init(name: String, quantity: Int = 1, notes: String? = nil) {
        self.name = name
        self.quantity = quantity
        self.notes = notes
    }
}

/// A simple collection of items held by an investigator.
public struct Inventory: Codable, Sendable, Equatable {
    public var items: [Item]

    public init(items: [Item] = []) {
        self.items = items
    }

    public mutating func add(_ item: Item) {
        items.append(item)
    }

    public mutating func remove(named name: String, quantity: Int = .max) {
        var remaining = quantity
        items.removeAll { item in
            guard item.name == name else { return false }
            if remaining >= item.quantity {
                remaining -= item.quantity
                return true
            }
            return false
        }
    }
}
