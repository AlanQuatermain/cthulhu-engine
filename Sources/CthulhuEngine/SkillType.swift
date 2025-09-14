import Foundation

/// Enumerates predefined Call of Cthulhu 7e skills, including specializations.
/// Includes a `.custom` case for non-standard skills.
public enum SkillType: Codable, Hashable, Sendable {
    case accounting
    case anthropology
    case appraise
    case archaeology
    case artCraft(specialization: String)
    case charm
    case climb
    case creditRating
    case cthulhuMythos
    case disguise
    case dodge
    case driveAuto
    case electricalRepair
    case fastTalk
    case fightingBrawl
    case fighting(specialization: String, base: Int = 25)
    case firearmsHandgun
    case firearmsRifleShotgun
    case firearms(specialization: String, base: Int = 20)
    case firstAid
    case history
    case intimidate
    case jump
    case languageOwn
    case languageOther(_ name: String)
    case law
    case libraryUse
    case listen
    case locksmith
    case mechanicalRepair
    case medicine
    case naturalWorld
    case navigate
    case occult
    case operateHeavyMachinery
    case persuade
    case pilot(_ name: String)
    case psychoanalysis
    case psychology
    case ride
    case science(_ name: String)
    case sleightOfHand
    case spotHidden
    case stealth
    case survival(_ name: String = "")
    case swim
    case `throw`
    case track

    case custom(name: String, base: Int)

    /// Display name for the skill, including specialization where applicable.
    public var displayName: String {
        switch self {
        case .accounting: return "Accounting"
        case .anthropology: return "Anthropology"
        case .appraise: return "Appraise"
        case .archaeology: return "Archaeology"
        case .artCraft(let spec): return spec.isEmpty ? "Art/Craft" : "Art/Craft (\(spec))"
        case .charm: return "Charm"
        case .climb: return "Climb"
        case .creditRating: return "Credit Rating"
        case .cthulhuMythos: return "Cthulhu Mythos"
        case .disguise: return "Disguise"
        case .dodge: return "Dodge"
        case .driveAuto: return "Drive Auto"
        case .electricalRepair: return "Electrical Repair"
        case .fastTalk: return "Fast Talk"
        case .fightingBrawl: return "Fighting (Brawl)"
        case .fighting(let spec, _): return "Fighting (\(spec))"
        case .firearmsHandgun: return "Firearms (Handgun)"
        case .firearmsRifleShotgun: return "Firearms (Rifle/Shotgun)"
        case .firearms(let spec, _): return "Firearms (\(spec))"
        case .firstAid: return "First Aid"
        case .history: return "History"
        case .intimidate: return "Intimidate"
        case .jump: return "Jump"
        case .languageOwn: return "Language (Own)"
        case .languageOther(let name): return "Language (\(name))"
        case .law: return "Law"
        case .libraryUse: return "Library Use"
        case .listen: return "Listen"
        case .locksmith: return "Locksmith"
        case .mechanicalRepair: return "Mechanical Repair"
        case .medicine: return "Medicine"
        case .naturalWorld: return "Natural World"
        case .navigate: return "Navigate"
        case .occult: return "Occult"
        case .operateHeavyMachinery: return "Operate Heavy Machinery"
        case .persuade: return "Persuade"
        case .pilot(let name): return "Pilot (\(name))"
        case .psychoanalysis: return "Psychoanalysis"
        case .psychology: return "Psychology"
        case .ride: return "Ride"
        case .science(let name): return "Science (\(name))"
        case .sleightOfHand: return "Sleight of Hand"
        case .spotHidden: return "Spot Hidden"
        case .stealth: return "Stealth"
        case .survival(let name): return name.isEmpty ? "Survival" : "Survival (\(name))"
        case .swim: return "Swim"
        case .`throw`: return "Throw"
        case .track: return "Track"
        case .custom(let name, _): return name
        }
    }

    /// Default base value for the skill per CoC 7e. Some depend on attributes.
    public func defaultBase(attributes: [Attribute: Int] = [:]) -> Int {
        switch self {
        case .accounting: return 5
        case .anthropology: return 1
        case .appraise: return 5
        case .archaeology: return 1
        case .artCraft: return 5
        case .charm: return 15
        case .climb: return 20
        case .creditRating: return 0
        case .cthulhuMythos: return 0
        case .disguise: return 5
        case .dodge: return (attributes[.dex] ?? 0) / 2
        case .driveAuto: return 20
        case .electricalRepair: return 10
        case .fastTalk: return 5
        case .fightingBrawl: return 25
        case .fighting(_, let base): return base
        case .firearmsHandgun: return 20
        case .firearmsRifleShotgun: return 25
        case .firearms(_, let base): return base
        case .firstAid: return 30
        case .history: return 5
        case .intimidate: return 15
        case .jump: return 20
        case .languageOwn: return attributes[.edu] ?? 0
        case .languageOther: return 1
        case .law: return 5
        case .libraryUse: return 20
        case .listen: return 20
        case .locksmith: return 1
        case .mechanicalRepair: return 10
        case .medicine: return 1
        case .naturalWorld: return 10
        case .navigate: return 10
        case .occult: return 5
        case .operateHeavyMachinery: return 1
        case .persuade: return 10
        case .pilot: return 1
        case .psychoanalysis: return 1
        case .psychology: return 10
        case .ride: return 5
        case .science: return 1
        case .sleightOfHand: return 10
        case .spotHidden: return 25
        case .stealth: return 20
        case .survival: return 10
        case .swim: return 20
        case .`throw`: return 20
        case .track: return 10
        case .custom(_, let base): return base
        }
    }
}

public extension Skill {
    /// Convenience initializer from a `SkillType`. If `value` is omitted, it defaults to the base.
    init(type: SkillType, value: Int? = nil, attributes: [Attribute: Int] = [:]) {
        let base = type.defaultBase(attributes: attributes)
        self.init(name: type.displayName, value: value ?? base, base: base, markedForImprovement: false)
    }
}

public extension CharacterSheet {
    /// Add or update a skill by type, using default base if value is omitted.
    mutating func setSkill(_ type: SkillType, value: Int? = nil) {
        let s = Skill(type: type, value: value, attributes: attributes)
        self.setSkill(s)
    }

    /// Lookup a skill by type.
    func skill(_ type: SkillType) -> Skill? { skills[type.displayName] }
}
