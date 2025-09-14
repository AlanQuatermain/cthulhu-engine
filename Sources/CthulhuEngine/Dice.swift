import Foundation
import DiceRoller

/// Utilities for evaluating DiceRoller expressions and rolling d100 with
/// advantage/disadvantage semantics used by Call of Cthulhu.
enum DiceUtil {
    /// Evaluate a DiceRoller expression and return its computed numeric value.
    static func rollValue(_ expression: String) throws -> Int {
        let (_, _, value) = try Roller().parse(input: expression)
        return value
    }

    /// Roll a d100 using expressions:
    /// - normal: `d%`
    /// - advantage: `(2d10kh1)*10+1d10`
    /// - disadvantage: `(2d10dh1)*10+1d10`
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
