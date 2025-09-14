import Foundation

/// Core Call of Cthulhu 7e characteristics.
/// Stored as percentage values (typically multiples of 5).
public enum Attribute: String, CaseIterable, Codable, Hashable, Sendable {
    case str, con, dex, app, pow, siz, int, edu

    /// The uppercase three-letter abbreviation (e.g. "STR").
    public var code: String {
        switch self {
        case .str: return "STR"
        case .con: return "CON"
        case .dex: return "DEX"
        case .app: return "APP"
        case .pow: return "POW"
        case .siz: return "SIZ"
        case .int: return "INT"
        case .edu: return "EDU"
        }
    }

    /// The full, human-readable name of the attribute.
    public var fullName: String {
        switch self {
        case .str: return "Strength"
        case .con: return "Constitution"
        case .dex: return "Dexterity"
        case .app: return "Appearance"
        case .pow: return "Power"
        case .siz: return "Size"
        case .int: return "Intelligence"
        case .edu: return "Education"
        }
    }
}

public extension Dictionary where Key == Attribute, Value == Int {
    /// Convenience to access a characteristic value; returns 0 when missing.
    subscript(_ attribute: Attribute) -> Int {
        get { return self[attribute, default: 0] }
        set { self[attribute] = newValue }
    }
}

public struct AttributeThresholds: Sendable, Codable, Equatable {
    public let value: Int
    public let half: Int
    public let fifth: Int

    public init(value: Int) {
        self.value = value
        self.half = value / 2
        self.fifth = value / 5
    }
}

