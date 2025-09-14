import Foundation

/// Represents a Call of Cthulhu skill measured as a percentage.
public struct Skill: Codable, Hashable, Sendable {
    public var name: String
    /// Current effective skill value (0-100+).
    public var value: Int
    /// Base value for the skill (rulebook default).
    public var base: Int
    /// Whether this skill is marked for improvement checks.
    public var markedForImprovement: Bool

    public init(name: String, value: Int, base: Int = 0, markedForImprovement: Bool = false) {
        self.name = name
        self.value = value
        self.base = base
        self.markedForImprovement = markedForImprovement
    }

    public var thresholds: AttributeThresholds { .init(value: value) }

    /// Returns the skill's displayable name.
    public func displayName() -> String { name }
}

public enum SuccessLevel: String, Codable, Equatable, Sendable {
    case fumble
    case failure
    case regular
    case hard
    case extreme
    case critical
}

public struct SkillTestResult: Codable, Equatable, Sendable {
    public let roll: Int
    public let success: SuccessLevel
}

public enum D100Mode: Sendable {
    case normal
    case advantage
    case disadvantage
}

public struct SkillTester: Sendable {
    public init() {}

    /// Perform a skill test, returning the success level according to CoC 7e.
    /// - Parameters:
    ///   - skill: The skill being tested.
    ///   - mode: D100 rolling mode (normal/advantage/disadvantage)
    /// - Returns: The die roll and success level.
    public func test(skill: Skill, mode: D100Mode = .normal) -> SkillTestResult {
        let roll = DiceUtil.rollD100(mode: mode)
        let success = SkillTester.determineSuccess(roll: roll, skillValue: skill.value)
        return .init(roll: roll, success: success)
    }

    /// Perform an attribute test against a raw attribute value.
    /// - Parameters:
    ///   - value: The attribute value to test against (0-100+).
    ///   - mode: D100 rolling mode (normal/advantage/disadvantage)
    /// - Returns: The die roll and success level.
    public func test(attribute value: Int, mode: D100Mode = .normal) -> SkillTestResult {
        let roll = DiceUtil.rollD100(mode: mode)
        let success = SkillTester.determineSuccess(roll: roll, skillValue: value)
        return .init(roll: roll, success: success)
    }

    /// Determine success level for a given d100 roll and skill value.
    public static func determineSuccess(roll: Int, skillValue: Int) -> SuccessLevel {
        let thresholds = AttributeThresholds(value: skillValue)

        if roll == 1 { return .critical }
        if (roll == 100) || (roll >= 96 && skillValue < 50) { return .fumble }

        if roll <= thresholds.fifth { return .extreme }
        if roll <= thresholds.half { return .hard }
        if roll <= thresholds.value { return .regular }
        return .failure
    }
}
