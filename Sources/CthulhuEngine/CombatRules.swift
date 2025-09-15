import Foundation

/// Era used to tag catalog weapons for quick filtering.
public enum Era: String, Codable, Sendable {
    case classic1920s
    case pulp1940s
}

/// Cover the target benefits from.
public enum Cover: String, Codable, Sendable {
    case none
    case light
    case medium
    case hard
}

/// Target size category.
public enum TargetSize: String, Codable, Sendable {
    case small   // e.g., head-sized
    case normal
    case large   // e.g., horse-sized
}

/// Options that influence an attack roll's difficulty and mode.
public struct AttackOptions: Codable, Sendable, Equatable {
    public var rangeYards: Int?
    public var cover: Cover
    public var targetSize: TargetSize
    public var aimed: Bool
    public var braced: Bool
    public var shooterMoving: Bool

    public init(rangeYards: Int? = nil,
                cover: Cover = .none,
                targetSize: TargetSize = .normal,
                aimed: Bool = false,
                braced: Bool = false,
                shooterMoving: Bool = false) {
        self.rangeYards = rangeYards
        self.cover = cover
        self.targetSize = targetSize
        self.aimed = aimed
        self.braced = braced
        self.shooterMoving = shooterMoving
    }
}

public enum DifficultyRequirement: Comparable {
    case regular
    case hard
    case extreme
}

public enum AttackModeCalculator {
    /// Map options to a single-step d100 mode (advantage/disadvantage/normal).
    /// This collapses multiple bonus/penalty influences into a single net result.
    public static func mode(for options: AttackOptions) -> D100Mode {
        var bonus = 0
        var penalty = 0
        if options.aimed { bonus += 1 }
        if options.braced { bonus += 1 }
        if options.shooterMoving { penalty += 1 }
        switch options.cover {
        case .light: penalty += 1
        case .medium: penalty += 1
        case .hard: penalty += 1
        case .none: break
        }
        switch options.targetSize {
        case .small: penalty += 1
        case .large: bonus += 1
        case .normal: break
        }
        let net = bonus - penalty
        if net > 0 { return .advantage }
        if net < 0 { return .disadvantage }
        return .normal
    }

    /// Determine the minimum success level required based on range and cover.
    /// - Parameters:
    ///   - options: Attack options including rangeYards and cover.
    ///   - weapon: Weapon with optional range profile to compare against.
    /// - Returns: The minimum success level needed.
    public static func requiredDifficulty(options: AttackOptions, weapon: Weapon) -> DifficultyRequirement {
        var req: DifficultyRequirement = .regular
        if let r = options.rangeYards, let profile = weapon.range {
            if let short = profile.short, r <= short { req = .regular }
            else if let medium = profile.medium, r <= medium { req = .hard }
            else if let long = profile.long, r <= long { req = .extreme }
            else { req = .extreme }
        }
        // Medium cover increases difficulty to at least Hard
        if options.cover == .medium && req < .hard { req = .hard }
        // Hard cover increases difficulty to at least Extreme
        if options.cover == .hard { req = .extreme }
        return req
    }

    /// Enforce a difficulty requirement on a success level, turning successes below the requirement into failures.
    public static func enforceRequirement(_ level: SuccessLevel, required: DifficultyRequirement) -> SuccessLevel {
        switch required {
        case .regular:
            return level
        case .hard:
            switch level {
            case .hard, .extreme, .critical: return level
            default: return .failure
            }
        case .extreme:
            switch level {
            case .extreme, .critical: return level
            default: return .failure
            }
        }
    }
}

