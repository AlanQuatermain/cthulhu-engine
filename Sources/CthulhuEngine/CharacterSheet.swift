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
    /// Optional maximum allowed skill value during character creation.
    public var creationSkillCap: Int?

    public init(name: String,
                occupation: String? = nil,
                age: Int? = nil,
                attributes: [Attribute: Int] = [:],
                skills: [String: Skill] = [:],
                inventory: Inventory = .init(),
                creationSkillCap: Int? = nil) {
        self.name = name
        self.occupation = occupation
        self.age = age
        self.attributes = attributes
        self.skills = skills
        self.inventory = inventory
        self.creationSkillCap = creationSkillCap
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

    // MARK: - Character creation helpers

    /// Set or clear the creation-time skill cap.
    mutating func setCreationSkillCap(_ cap: Int?) {
        self.creationSkillCap = cap
    }

    /// Add points to a named skill, applying a cap if provided or if `creationSkillCap` is set.
    /// If the skill does not exist, it will be created with a base of 0.
    mutating func addToSkill(named name: String, amount: Int, cap: Int? = nil) {
        guard amount != 0 else { return }
        var skill = skills[name] ?? Skill(name: name, value: 0, base: 0)
        let appliedCap = cap ?? creationSkillCap ?? Int.max
        let added = max(0, amount)
        let newValue = min(skill.value + added, appliedCap)
        skill.value = newValue
        skills[name] = skill
    }

    /// Add points to a typed skill, creating it from its base if missing. Applies creation cap.
    mutating func addToSkill(_ type: SkillType, amount: Int, cap: Int? = nil) {
        let name = type.displayName
        if var existing = skills[name] {
            let appliedCap = cap ?? creationSkillCap ?? Int.max
            let added = max(0, amount)
            existing.value = min(existing.value + added, appliedCap)
            skills[name] = existing
        } else {
            var skill = Skill(type: type, attributes: attributes)
            let appliedCap = cap ?? creationSkillCap ?? Int.max
            let added = max(0, amount)
            skill.value = min(skill.value + added, appliedCap)
            skills[name] = skill
        }
    }

    /// Perform improvement checks for all skills marked for improvement.
    ///
    /// - Parameter maxSkillCap: Maximum cap applied to post-improvement value (default 100).
    /// - Returns: A list of improvement results per skill processed.
    @discardableResult
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
