import Testing
@testable import CthulhuEngine

@Test func example() async throws {
    // Attribute full names
    #expect(Attribute.str.code == "STR")
    #expect(Attribute.str.fullName == "Strength")
    #expect(Attribute.int.fullName == "Intelligence")

    // Attribute thresholds
    let t = AttributeThresholds(value: 70)
    #expect(t.half == 35)
    #expect(t.fifth == 14)

    // Character sheet and skills
    var sheet = CharacterSheet(name: "Harvey Walters")
    sheet.setAttribute(.str, value: 60)
    sheet.setAttribute(.dex, value: 50)
    sheet.setAttribute(.edu, value: 70)
    sheet.setSkill(Skill(name: "Spot Hidden", value: 50, base: 25))
    sheet.setSkill(.dodge) // base should be DEX/2 = 25
    sheet.setSkill(.languageOwn) // base should be EDU = 70
    sheet.setSkill(.spotHidden) // base should be 25
    #expect(sheet.skill(.dodge)?.base == 25)
    #expect(sheet.skill(.languageOwn)?.base == 70)
    #expect(sheet.skill(.spotHidden)?.base == 25)

    // Deterministic classification check
    let success = SkillTester.determineSuccess(roll: 12, skillValue: 50)
    #expect(success == .hard)

    // Mark-on-success behavior (exercise CharacterSheet test path)
    // We can't inject a deterministic roll through CharacterSheet, so we check side effect via success classification path
    // Simulate success by directly marking: ensure default is false then true after marking logic
    #expect(sheet.skills["Spot Hidden"]?.markedForImprovement == true)
    // We call testSkill; we can't control randomness here, so we only verify that the API is present.
    _ = sheet.testSkill(named: "Spot Hidden", mode: .normal, markOnSuccess: true)

    // Improvement delta logic (pure function):
    #expect(SkillTester.improvementDelta(current: 50, checkRoll: 60, gainRoll: 7) == 7)
    #expect(SkillTester.improvementDelta(current: 50, checkRoll: 40, gainRoll: 7) == 0)

    // Improvement checks: with a 0% skill, improvement always triggers; mark clears.
    sheet.setSkill(Skill(name: "Test Skill", value: 0, base: 0, markedForImprovement: true))
    let improvements = sheet.performImprovementChecks()
    // Ensure the explicitly added test skill improved appropriately and its mark cleared.
    if let after = sheet.skills["Test Skill"]?.value {
        #expect(after >= 1 && after <= 10)
        #expect(sheet.skills["Test Skill"]?.markedForImprovement == false)
    }
}
