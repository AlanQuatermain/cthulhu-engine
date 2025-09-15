import Testing
@testable import CthulhuEngine

@Suite struct RulesSuite {
    @Test func modeAggregation() {
        let a = AttackOptions(cover: .none, targetSize: .large, aimed: true, braced: false, shooterMoving: false)
        #expect(AttackModeCalculator.mode(for: a) == .advantage)
        let b = AttackOptions(cover: .medium, targetSize: .small, aimed: false, braced: false, shooterMoving: true)
        #expect(AttackModeCalculator.mode(for: b) == .disadvantage)
        let c = AttackOptions(cover: .light, targetSize: .large, aimed: false, braced: false, shooterMoving: false)
        #expect(AttackModeCalculator.mode(for: c) == .normal)
    }

    @Test func requiredDifficultyWithRangeAndCover() {
        let rifle = WeaponsCatalog.rifle303
        let near = AttackOptions(rangeYards: 50)
        #expect(AttackModeCalculator.requiredDifficulty(options: near, weapon: rifle) == .regular)
        let med = AttackOptions(rangeYards: 150)
        #expect(AttackModeCalculator.requiredDifficulty(options: med, weapon: rifle) == .hard)
        let long = AttackOptions(rangeYards: 300)
        #expect(AttackModeCalculator.requiredDifficulty(options: long, weapon: rifle) == .extreme)
        let hardCover = AttackOptions(rangeYards: 50, cover: .hard)
        #expect(AttackModeCalculator.requiredDifficulty(options: hardCover, weapon: rifle) == .extreme)
    }

    @Test func enforceRequirement() {
        #expect(AttackModeCalculator.enforceRequirement(.regular, required: .regular) == .regular)
        #expect(AttackModeCalculator.enforceRequirement(.regular, required: .hard) == .failure)
        #expect(AttackModeCalculator.enforceRequirement(.hard, required: .hard) == .hard)
        #expect(AttackModeCalculator.enforceRequirement(.hard, required: .extreme) == .failure)
        #expect(AttackModeCalculator.enforceRequirement(.extreme, required: .extreme) == .extreme)
    }
}

