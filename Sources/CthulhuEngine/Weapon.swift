import Foundation

/// Describes a weapon and its damage expression.
public struct Weapon: Codable, Hashable, Sendable {
    public var name: String
    public var damage: WeaponDamage
    public var skill: SkillType?
    public var notes: String?
    public var isImpaling: Bool
    public var range: RangeProfile?
    public var ammoCapacity: Int?
    public var rateOfFire: Int?
    public var malfunctionOn: Int?

    public init(name: String,
                damage: WeaponDamage,
                skill: SkillType? = nil,
                notes: String? = nil,
                isImpaling: Bool = false,
                range: RangeProfile? = nil,
                ammoCapacity: Int? = nil,
                rateOfFire: Int? = nil,
                malfunctionOn: Int? = nil) {
        self.name = name
        self.damage = damage
        self.skill = skill
        self.notes = notes
        self.isImpaling = isImpaling
        self.range = range
        self.ammoCapacity = ammoCapacity
        self.rateOfFire = rateOfFire
        self.malfunctionOn = malfunctionOn
    }

    /// Roll damage using the provided context (e.g., damage bonus).
    public func rollDamage(context: DamageContext = .init(), impale: Bool = false) -> DamageRollResult {
        damage.roll(context: context, impale: impale && isImpaling)
    }
}

/// Simple range profile (yards) for a weapon. Extend as needed for band rules.
public struct RangeProfile: Codable, Hashable, Sendable {
    public var short: Int?
    public var medium: Int?
    public var long: Int?

    public init(short: Int? = nil, medium: Int? = nil, long: Int? = nil) {
        self.short = short
        self.medium = medium
        self.long = long
    }
}

/// Defines how a weapon's damage should be computed using a DiceRoller expression.
///
/// Supports variable placeholders in braces, e.g. `{DB}` for damage bonus.
public struct WeaponDamage: Codable, Hashable, Sendable {
    public var expression: String
    /// Optional alternate expression for an 'impale' result.
    public var impaleExpression: String?

    public init(expression: String, impaleExpression: String? = nil) {
        self.expression = expression
        self.impaleExpression = impaleExpression
    }

    public func roll(context: DamageContext = .init(), impale: Bool = false) -> DamageRollResult {
        let base = impale ? (impaleExpression ?? expression) : expression
        let resolved: String
        if let db = context.damageBonusExpression {
            resolved = DiceUtil.resolve(expression: base, stringVariables: ["DB": db])
        } else {
            resolved = DiceUtil.resolve(expression: base, stringVariables: [:])
        }
        let value = (try? DiceUtil.rollValue(resolved)) ?? 0
        return DamageRollResult(input: base, resolved: resolved, value: value)
    }
}

/// Context for damage rolls, such as STR/SIZ damage bonus.
public struct DamageContext: Codable, Hashable, Sendable {
    /// Damage bonus expression to add for melee weapons; used when the damage expression contains `{DB}`.
    /// Examples: "-2", "0", "1d4", "1d6".
    public var damageBonusExpression: String?

    public init(damageBonus: Int? = nil, damageBonusExpression: String? = nil) {
        if let expr = damageBonusExpression {
            self.damageBonusExpression = expr
        } else if let v = damageBonus {
            self.damageBonusExpression = String(v)
        } else {
            self.damageBonusExpression = nil
        }
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
                                     damage: .init(expression: "1d4+{DB}", impaleExpression: "4+1d4+{DB}"),
                                     skill: .fighting(specialization: "Knife"),
                                     isImpaling: true)

    /// Club: 1d6+{DB}
    public static let club = Weapon(name: "Club",
                                    damage: .init(expression: "1d6+{DB}"),
                                    skill: .fighting(specialization: "Club"))

    /// Generic handgun: 1d10 (use specific stats at your table).
    public static let handgun = Weapon(name: "Handgun",
                                       damage: .init(expression: "1d10"),
                                       skill: .firearmsHandgun,
                                       notes: nil,
                                       isImpaling: false,
                                       range: .init(short: 15, medium: 30, long: 60),
                                       ammoCapacity: 6,
                                       rateOfFire: 1,
                                       malfunctionOn: 100)
}
