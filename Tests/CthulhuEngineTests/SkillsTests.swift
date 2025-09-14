import Testing
@testable import CthulhuEngine

@Suite struct SkillsSuite {
    @Test func displayName() {
        let s = Skill(name: "Spot Hidden", value: 50, base: 25)
        #expect(s.displayName() == "Spot Hidden")
    }

    @Test func determineSuccessBoundaries() {
        // Critical and fumble
        #expect(SkillTester.determineSuccess(roll: 1, skillValue: 10) == .critical)
        #expect(SkillTester.determineSuccess(roll: 100, skillValue: 80) == .fumble)
        #expect(SkillTester.determineSuccess(roll: 96, skillValue: 40) == .fumble) // 96-100 if < 50

        // Thresholds for value 70
        #expect(SkillTester.determineSuccess(roll: 14, skillValue: 70) == .extreme)
        #expect(SkillTester.determineSuccess(roll: 15, skillValue: 70) == .hard)
        #expect(SkillTester.determineSuccess(roll: 35, skillValue: 70) == .hard)
        #expect(SkillTester.determineSuccess(roll: 36, skillValue: 70) == .regular)
        #expect(SkillTester.determineSuccess(roll: 70, skillValue: 70) == .regular)
        #expect(SkillTester.determineSuccess(roll: 71, skillValue: 70) == .failure)
    }
}

