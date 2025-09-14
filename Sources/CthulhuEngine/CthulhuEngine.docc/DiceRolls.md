# Dice Rolls and Advantage

How d100 rolls are performed and how to use advantage and disadvantage.

## Expressions

The library uses DiceRoller to evaluate these expressions:

- Normal: `d%`
- Advantage: `(2d10kh1)*10+1d10`
- Disadvantage: `(2d10dh1)*10+1d10`

These model rolling the tens die twice and keeping/dropping the highest.

## Running Rolls

```swift
// Via CharacterSheet
_ = sheet.testSkill(named: "Spot Hidden")
_ = sheet.testSkill(named: "Spot Hidden", mode: .advantage)
_ = sheet.testSkill(named: "Spot Hidden", mode: .disadvantage)

// Attribute roll
let r = sheet.testAttribute(.pow)

// Access the raw value when needed
let value = try? DiceUtil.rollValue("4d6kh3")
```

