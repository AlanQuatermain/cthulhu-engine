# Advance Your Investigator

Improve skills through checks, handle exceptions, and use creation caps.

## Perform Improvement Checks

Run checks for all marked skills and inspect results.

Mark a skill and run checks:

```swift
sheet.skills["Spot Hidden"]?.markedForImprovement = true
let results = sheet.performImprovementChecks()
for r in results { print(r) }
```

Credit Rating and Cthulhu Mythos skip improvement via checks:

```swift
sheet.setSkill(.creditRating, value: 30)
sheet.skills["Credit Rating"]?.markedForImprovement = true
_ = sheet.performImprovementChecks()
// Value unchanged and mark cleared
```

## Creation Caps and Point Allocation

Apply a creation-time cap and allocate points to skills.

```swift
sheet.setCreationSkillCap(75)
sheet.setSkill(.spotHidden) // base 25
sheet.addToSkill(.spotHidden, amount: 100) // => 75

sheet.addToSkill(named: "Custom Skill", amount: 120, cap: 60) // => 60
```

