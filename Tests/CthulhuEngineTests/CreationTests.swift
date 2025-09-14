import Testing
@testable import CthulhuEngine

@Suite struct CreationSuite {
    @Test func creationCapAndAddHelpers() {
        var sheet = CharacterSheet(name: "Investigator")
        sheet.setCreationSkillCap(75)
        sheet.setSkill(.spotHidden)
        sheet.addToSkill(.spotHidden, amount: 100) // base 25 + 100 => 75 cap
        #expect(sheet.skill(.spotHidden)?.value == 75)

        sheet.addToSkill(named: "Custom Skill", amount: 120, cap: 60)
        #expect(sheet.skills["Custom Skill"]?.value == 60)
    }
}

