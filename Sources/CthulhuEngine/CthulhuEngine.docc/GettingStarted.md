# Getting Started

Learn the basics: create a sheet, set attributes and skills, and run d100 tests.

## Create a CharacterSheet

```swift
import CthulhuEngine

var sheet = CharacterSheet(name: "Harvey Walters")
sheet.setAttribute(.dex, value: 60)
sheet.setAttribute(.edu, value: 70)

// Add a predefined skill using SkillType (base values are applied automatically)
sheet.setSkill(.spotHidden)              // base 25
sheet.setSkill(.dodge)                   // base DEX/2 => 30
sheet.setSkill(.languageOwn)             // base EDU  => 70

// Add a custom skill
sheet.setSkill(Skill(name: "Archaeobotany", value: 5, base: 5))
```

## Run Skill Tests

```swift
// Normal d100 roll
if let result = sheet.testSkill(named: "Spot Hidden") {
    print("Rolled: \(result.roll), success: \(result.success)")
}

// With advantage or disadvantage
_ = sheet.testSkill(named: "Spot Hidden", mode: .advantage)
_ = sheet.testSkill(named: "Spot Hidden", mode: .disadvantage)

// Mark-on-success defaults to true; pass false to disable marking
_ = sheet.testSkill(named: "Spot Hidden", markOnSuccess: false)
```

## Attribute Checks

```swift
let powCheck = sheet.testAttribute(.pow)
print(powCheck.success)
```

## Notes

- d100 rolling uses DiceRoller expressions: `d%` (normal), `(2d10kh1)*10+1d10` (advantage), `(2d10dh1)*10+1d10` (disadvantage).
- Critical on 1. Fumble on 100, or 96–100 if the skill is below 50.

