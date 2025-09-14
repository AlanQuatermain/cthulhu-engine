import Testing
@testable import CthulhuEngine

@Suite struct ImprovementSuite {
    @Test func pureImprovementDelta() {
        #expect(SkillTester.improvementDelta(current: 50, checkRoll: 60, gainRoll: 7) == 7)
        #expect(SkillTester.improvementDelta(current: 50, checkRoll: 40, gainRoll: 7) == 0)
    }

    @Test func improvesFromZeroAndClearsMark() {
        var sheet = CharacterSheet(name: "Investigator")
        sheet.setSkill(Skill(name: "Test Skill", value: 0, base: 0, markedForImprovement: true))
        _ = sheet.performImprovementChecks()
        if let after = sheet.skills["Test Skill"]?.value {
            #expect(after >= 1 && after <= 10)
            #expect(sheet.skills["Test Skill"]?.markedForImprovement == false)
        }
    }

    @Test func skipsMythosAndCreditRating() {
        var sheet = CharacterSheet(name: "Investigator")
        sheet.setSkill(Skill(type: .cthulhuMythos, value: 10, attributes: [:]))
        sheet.setSkill(Skill(type: .creditRating, value: 20, attributes: [:]))
        sheet.skills["Cthulhu Mythos"]?.markedForImprovement = true
        sheet.skills["Credit Rating"]?.markedForImprovement = true
        _ = sheet.performImprovementChecks()
        #expect(sheet.skills["Cthulhu Mythos"]?.value == 10)
        #expect(sheet.skills["Credit Rating"]?.value == 20)
        #expect(sheet.skills["Cthulhu Mythos"]?.markedForImprovement == false)
        #expect(sheet.skills["Credit Rating"]?.markedForImprovement == false)
    }
}

