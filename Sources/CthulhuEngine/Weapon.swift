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

    /// Sword: 1d8+{DB} (impaling)
    public static let sword = Weapon(name: "Sword",
                                     damage: .init(expression: "1d8+{DB}", impaleExpression: "8+1d8+{DB}"),
                                     skill: .fighting(specialization: "Sword"),
                                     isImpaling: true)

    /// Hatchet: 1d6+{DB} (impaling)
    public static let hatchet = Weapon(name: "Hatchet",
                                       damage: .init(expression: "1d6+{DB}", impaleExpression: "6+1d6+{DB}"),
                                       skill: .fighting(specialization: "Axe"),
                                       isImpaling: true)

    /// Spear: 1d8+{DB} (impaling)
    public static let spear = Weapon(name: "Spear",
                                     damage: .init(expression: "1d8+{DB}", impaleExpression: "8+1d8+{DB}"),
                                     skill: .fighting(specialization: "Spear"),
                                     isImpaling: true)

    /// Crowbar: 1d6+{DB}
    public static let crowbar = Weapon(name: "Crowbar",
                                       damage: .init(expression: "1d6+{DB}"),
                                       skill: .fighting(specialization: "Club"))

    /// Brass Knuckles: 1d3+{DB} (simulate 1d3 via (1d6+1)/2)
    public static let brassKnuckles = Weapon(name: "Brass Knuckles",
                                             damage: .init(expression: "(1d6+1)/2+{DB}"),
                                             skill: .fightingBrawl)

    /// .45 Pistol: 1d10
    public static let pistol45 = Weapon(name: ".45 Pistol",
                                        damage: .init(expression: "1d10"),
                                        skill: .firearmsHandgun,
                                        range: .init(short: 15, medium: 30, long: 60),
                                        ammoCapacity: 7,
                                        rateOfFire: 1,
                                        malfunctionOn: 100)

    /// .303 Rifle: 2d6+4
    public static let rifle303 = Weapon(name: ".303 Rifle",
                                        damage: .init(expression: "2d6+4"),
                                        skill: .firearmsRifleShotgun,
                                        range: .init(short: 110, medium: 220, long: 440),
                                        ammoCapacity: 10,
                                        rateOfFire: 1,
                                        malfunctionOn: 100)

    /// 12g Shotgun (close): 4d6
    public static let shotgun12gClose = Weapon(name: "12g Shotgun (Close)",
                                               damage: .init(expression: "4d6"),
                                               skill: .firearmsRifleShotgun,
                                               range: .init(short: 10, medium: 20, long: 50),
                                               ammoCapacity: 2,
                                               rateOfFire: 2,
                                               malfunctionOn: 100)

    /// 12g Shotgun (medium): 2d6
    public static let shotgun12gMedium = Weapon(name: "12g Shotgun (Medium)",
                                                damage: .init(expression: "2d6"),
                                                skill: .firearmsRifleShotgun,
                                                range: .init(short: 10, medium: 20, long: 50),
                                                ammoCapacity: 2,
                                                rateOfFire: 2,
                                                malfunctionOn: 100)

    /// 12g Shotgun (long): 1d6
    public static let shotgun12gLong = Weapon(name: "12g Shotgun (Long)",
                                              damage: .init(expression: "1d6"),
                                              skill: .firearmsRifleShotgun,
                                              range: .init(short: 10, medium: 20, long: 50),
                                              ammoCapacity: 2,
                                              rateOfFire: 2,
                                              malfunctionOn: 100)
}
