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
    mutating func testSkill(named name: String,
                            mode: D100Mode = .normal,
                            markOnSuccess: Bool = true,
                            using tester: SkillTester = SkillTester()) -> SkillTestResult? {
        guard var skill = skills[name] else { return nil }
        let result = tester.test(skill: skill, mode: mode)
        if markOnSuccess, result.success != .failure, result.success != .fumble {
            skill.markedForImprovement = true
            skills[name] = skill
        }
        return result
    }

    /// Perform a characteristic test (e.g., STR, DEX, POW) using d100 mechanics.
    func testAttribute(_ attr: Attribute, mode: D100Mode = .normal, using tester: SkillTester = SkillTester()) -> SkillTestResult {
        let value = attributes[attr] ?? 0
        return tester.test(attribute: value, mode: mode)
    }

    /// Perform improvement checks for all skills marked for improvement.
    ///
    /// - Parameter maxSkillCap: Maximum cap applied to post-improvement value (default 100).
    /// - Returns: A list of improvement results per skill processed.
    mutating func performImprovementChecks(maxSkillCap: Int = 99) -> [SkillImprovementResult] {
        var results: [SkillImprovementResult] = []
        for (key, var skill) in skills where skill.markedForImprovement {
            // Skills that do not improve via checks
            if skill.name == "Cthulhu Mythos" || skill.name == "Credit Rating" {
                let before = skill.value
                skill.markedForImprovement = false
                skills[key] = skill
                results.append(SkillImprovementResult(name: skill.name,
                                                      before: before,
                                                      checkRoll: 0,
                                                      gained: 0,
                                                      after: before,
                                                      improved: false))
                continue
            }
            let check = (try? DiceUtil.rollValue("d%")) ?? Int.random(in: 1...100)
            let gain = (try? DiceUtil.rollValue("1d10")) ?? Int.random(in: 1...10)
            let before = skill.value
            let delta = SkillTester.improvementDelta(current: before, checkRoll: check, gainRoll: gain)
            let after = min(before + delta, maxSkillCap)
            let improved = after > before
            skill.value = after
            skill.markedForImprovement = false
            skills[key] = skill

            results.append(SkillImprovementResult(name: skill.name,
                                                  before: before,
                                                  checkRoll: check,
                                                  gained: improved ? (after - before) : 0,
                                                  after: after,
                                                  improved: improved))
        }
        return results
    }
}
