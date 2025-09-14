import Testing
@testable import CthulhuEngine

@Suite struct DiceSuite {
    @Test func percentRollRange() throws {
        let value = (try? DiceUtil.rollValue("d%")) ?? 0
        #expect(1...100 ~= value)
    }

    @Test func advantageExpressionRange() throws {
        let value = (try? DiceUtil.rollValue("(2d10kh1)*10+1d10")) ?? 0
        #expect(11...110 ~= value)
    }

    @Test func disadvantageExpressionRange() throws {
        let value = (try? DiceUtil.rollValue("(2d10dh1)*10+1d10")) ?? 0
        #expect(11...110 ~= value)
    }
}

