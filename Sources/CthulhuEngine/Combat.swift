import Foundation

/// The outcome of an attack: a skill test and any resulting damage.
public struct AttackResult: Codable, Sendable, Equatable {
    public let weapon: Weapon
    public let test: SkillTestResult
    public let damage: DamageRollResult?
    public let impaled: Bool
    public var hit: Bool { test.success != .failure && test.success != .fumble }
}

public enum AttackResolver {
    /// Compute damage for a given success level. Returns `nil` damage for failure/fumble.
    public static func damage(for weapon: Weapon, success: SuccessLevel, context: DamageContext) -> (DamageRollResult?, Bool) {
        switch success {
        case .failure, .fumble:
            return (nil, false)
        case .extreme:
            if weapon.isImpaling {
                return (weapon.rollDamage(context: context, impale: true), true)
            } else {
                return (weapon.rollDamage(context: context, impale: false), false)
            }
        case .hard, .regular, .critical:
            return (weapon.rollDamage(context: context, impale: false), false)
        }
    }
}

public extension CharacterSheet {
    /// Perform an attack roll with the given weapon and skill name.
    /// - Parameters:
    ///   - weapon: The weapon used for the attack.
    ///   - skillName: The skill to test (must exist on the sheet).
    ///   - mode: D100 rolling mode (normal/advantage/disadvantage).
    ///   - markOnSuccess: Whether to mark the skill on success. Defaults to true.
    /// - Returns: An `AttackResult` if the skill is found; otherwise `nil`.
    mutating func performAttack(weapon: Weapon,
                                usingSkillNamed skillName: String,
                                mode: D100Mode = .normal,
                                markOnSuccess: Bool = true) -> AttackResult? {
        guard let skill = skills[skillName] else { return nil }
        let test = SkillTester().test(skill: skill, mode: mode)
        if markOnSuccess, test.success != .failure, test.success != .fumble {
            var updated = skill
            updated.markedForImprovement = true
            skills[skillName] = updated
        }
        let ctx = damageContext()
        let (dmg, impaled) = AttackResolver.damage(for: weapon, success: test.success, context: ctx)
        return AttackResult(weapon: weapon, test: test, damage: dmg, impaled: impaled)
    }

    /// Perform an attack roll with the given weapon and typed skill.
    mutating func performAttack(weapon: Weapon,
                                using skill: SkillType,
                                mode: D100Mode = .normal,
                                markOnSuccess: Bool = true) -> AttackResult? {
        performAttack(weapon: weapon, usingSkillNamed: skill.displayName, mode: mode, markOnSuccess: markOnSuccess)
    }
}

