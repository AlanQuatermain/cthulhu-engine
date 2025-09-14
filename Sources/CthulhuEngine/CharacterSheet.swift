import Foundation

/// Represents an investigator/character in Call of Cthulhu.
public struct CharacterSheet: Codable, Sendable, Equatable {
    public var name: String
    public var occupation: String?
    public var age: Int?

    /// Primary characteristics (percent values, typically multiples of 5).
    public var attributes: [Attribute: Int]

    /// Known skills keyed by name (case-sensitive for now).
    public var skills: [String: Skill]

    public var inventory: Inventory

    public init(name: String,
                occupation: String? = nil,
                age: Int? = nil,
                attributes: [Attribute: Int] = [:],
                skills: [String: Skill] = [:],
                inventory: Inventory = .init()) {
        self.name = name
        self.occupation = occupation
        self.age = age
        self.attributes = attributes
        self.skills = skills
        self.inventory = inventory
    }

    public func attribute(_ attr: Attribute) -> Int { attributes[attr] ?? 0 }

    public mutating func setAttribute(_ attr: Attribute, value: Int) {
        attributes[attr] = value
    }

    public mutating func setSkill(_ skill: Skill) {
        skills[skill.name] = skill
    }

    public func thresholds(for attr: Attribute) -> AttributeThresholds { .init(value: attributes[attr] ?? 0) }
}

public extension CharacterSheet {
    /// Perform a skill test for a named skill using the provided tester.
    func testSkill(named name: String, mode: D100Mode = .normal, using tester: SkillTester = SkillTester()) -> SkillTestResult? {
        guard let skill = skills[name] else { return nil }
        return tester.test(skill: skill, mode: mode)
    }
}
