import Foundation

/// Describes a weapon and its damage expression.
public struct Weapon: Codable, Hashable, Sendable {
    public var name: String
    public var damage: WeaponDamage
    public var skill: SkillType?
    public var notes: String?

    public init(name: String, damage: WeaponDamage, skill: SkillType? = nil, notes: String? = nil) {
        self.name = name
        self.damage = damage
        self.skill = skill
        self.notes = notes
    }

    /// Roll damage using the provided context (e.g., damage bonus).
    public func rollDamage(context: DamageContext = .init()) -> DamageRollResult {
        damage.roll(context: context)
    }
}

/// Defines how a weapon's damage should be computed using a DiceRoller expression.
///
/// Supports variable placeholders in braces, e.g. `{DB}` for damage bonus.
public struct WeaponDamage: Codable, Hashable, Sendable {
    public var expression: String

    public init(expression: String) { self.expression = expression }

    public func roll(context: DamageContext = .init()) -> DamageRollResult {
        let resolved = DiceUtil.resolve(expression: expression, variables: context.variables)
        let value = (try? DiceUtil.rollValue(resolved)) ?? 0
        return DamageRollResult(input: expression, resolved: resolved, value: value)
    }
}

/// Context for damage rolls, such as STR/SIZ damage bonus.
public struct DamageContext: Codable, Hashable, Sendable {
    /// Damage bonus to add for melee weapons; used when the damage expression contains `{DB}`.
    public var damageBonus: Int?

    public init(damageBonus: Int? = nil) { self.damageBonus = damageBonus }

    var variables: [String: Int] {
        var v: [String: Int] = [:]
        if let db = damageBonus { v["DB"] = db }
        return v
    }
}

/// Result of a weapon damage roll, including the resolved expression and numeric value.
public struct DamageRollResult: Codable, Hashable, Sendable {
    public let input: String
    public let resolved: String
    public let value: Int
}

public enum WeaponsCatalog {
    /// Unarmed (Brawl): 1d3+{DB}
    public static let unarmedBrawl = Weapon(name: "Unarmed (Brawl)",
                                            damage: .init(expression: "(1d6+1)/2+{DB}"),
                                            skill: .fightingBrawl)

    /// Knife: 1d4+{DB}
    public static let knife = Weapon(name: "Knife",
                                     damage: .init(expression: "1d4+{DB}"),
                                     skill: .fighting(specialization: "Knife"))

    /// Club: 1d6+{DB}
    public static let club = Weapon(name: "Club",
                                    damage: .init(expression: "1d6+{DB}"),
                                    skill: .fighting(specialization: "Club"))

    /// Generic handgun: 1d10 (use specific stats at your table).
    public static let handgun = Weapon(name: "Handgun",
                                       damage: .init(expression: "1d10"),
                                       skill: .firearmsHandgun)
}
