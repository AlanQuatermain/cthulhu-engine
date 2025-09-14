# Skills and Attributes

Understand attribute names and thresholds, skill bases, and creating skills.

## Attributes

```swift
Attribute.str.code       // "STR"
Attribute.str.fullName   // "Strength"

let t = AttributeThresholds(value: 70)
t.half   // 35
t.fifth  // 14
```

## SkillType and Base Values

`SkillType` models predefined CoC 7e skills, including specializations:

- Examples: `.spotHidden`, `.dodge`, `.languageOwn`, `.fightingBrawl`, `.firearmsHandgun`, `.artCraft(specialization:)`, `.science(_:)`, `.custom(name:base:)`.
- Attribute-derived bases:
  - Dodge = DEX/2
  - Language (Own) = EDU

```swift
var sheet = CharacterSheet(name: "Investigator")
sheet.setAttribute(.dex, value: 60)
sheet.setAttribute(.edu, value: 70)

sheet.setSkill(.dodge)              // base 30
sheet.setSkill(.languageOwn)        // base 70
sheet.setSkill(.spotHidden)         // base 25

// From SkillType directly
let s = Skill(type: .science("Botany"), attributes: sheet.attributes) // base 1
```

## Success Levels

`SkillTester.determineSuccess(roll:skillValue:)` classifies rolls as:

- `critical` on 1
- `fumble` on 100, or 96–100 if skill < 50
- `extreme`, `hard`, `regular`, `failure` per fifth/half/value thresholds

```swift
SkillTester.determineSuccess(roll: 14, skillValue: 70)   // .extreme
SkillTester.determineSuccess(roll: 35, skillValue: 70)   // .hard
SkillTester.determineSuccess(roll: 70, skillValue: 70)   // .regular
SkillTester.determineSuccess(roll: 71, skillValue: 70)   // .failure
```

