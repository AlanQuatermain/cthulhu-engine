import Testing
@testable import CthulhuEngine

@Suite struct CharacterSheetSuite {
    @Test func skillTypeBaseValues() {
        var sheet = CharacterSheet(name: "Investigator")
        sheet.setAttribute(.dex, value: 50)
        sheet.setAttribute(.edu, value: 70)
        sheet.setSkill(.dodge) // base DEX/2 = 25
        sheet.setSkill(.languageOwn) // base EDU = 70
        sheet.setSkill(.spotHidden) // base 25
        #expect(sheet.skill(.dodge)?.base == 25)
        #expect(sheet.skill(.languageOwn)?.base == 70)
        #expect(sheet.skill(.spotHidden)?.base == 25)
    }

    @Test func markOnSuccessDefaultIsTrueButCanBeDisabled() {
        var sheet = CharacterSheet(name: "Investigator")
        sheet.setSkill(Skill(name: "Spot Hidden", value: 50, base: 25, markedForImprovement: false))
        _ = sheet.testSkill(named: "Spot Hidden", markOnSuccess: false)
        #expect(sheet.skills["Spot Hidden"]?.markedForImprovement == false)
    }
}

