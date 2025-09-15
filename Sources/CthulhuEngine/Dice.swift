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

    /// Resolve integer variables embedded in braces within an expression, e.g.,
    /// `"1d6+{DB}"` with variables `["DB": 2]` becomes `"1d6+2"`.
    static func resolve(expression: String, variables: [String: Int]) -> String {
        var result = expression
        if !variables.isEmpty {
            for (key, value) in variables {
                // Replace occurrences of {KEY} (case-sensitive)
                let token = "{\(key)}"
                result = result.replacingOccurrences(of: token, with: String(value))
            }
        }
        // Replace any unresolved placeholders with 0 (currently {DB} is supported)
        if result.contains("{") {
            result = result.replacingOccurrences(of: "{DB}", with: "0")
        }
        // Normalize no-op math
        result = result.replacingOccurrences(of: "+0", with: "")
        result = result.replacingOccurrences(of: "0+", with: "")
        result = result.replacingOccurrences(of: "-0", with: "")
        return result
    }

    /// Resolve string variables embedded in braces within an expression, e.g.,
    /// `"1d4+{DB}"` with variables `["DB": "1d4"]` becomes `"1d4+1d4"`.
    static func resolve(expression: String, stringVariables: [String: String]) -> String {
        var result = expression
        if !stringVariables.isEmpty {
            for (key, value) in stringVariables {
                let token = "{\(key)}"
                result = result.replacingOccurrences(of: token, with: value)
            }
        }
        // Replace any unresolved placeholders with 0
        if result.contains("{") {
            result = result.replacingOccurrences(of: "{DB}", with: "0")
        }
        // Normalize trivial math with +0 or -0
        result = result.replacingOccurrences(of: "+0", with: "")
        result = result.replacingOccurrences(of: "0+", with: "")
        result = result.replacingOccurrences(of: "-0", with: "")
        return result
    }
}
