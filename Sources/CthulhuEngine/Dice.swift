import Foundation
import DiceRoller

enum DiceUtil {
    static func rollValue(_ expression: String) throws -> Int {
        let (_, _, value) = try Roller().parse(input: expression)
        return value
    }

    static func rollD100(mode: D100Mode) -> Int {
        let expr: String
        switch mode {
        case .normal:
            expr = "d%"
        case .advantage:
            expr = "(2d10kh1)*10+1d10"
        case .disadvantage:
            expr = "(2d10dh1)*10+1d10"
        }
        return (try? rollValue(expr)) ?? Int.random(in: 1...100)
    }
}

