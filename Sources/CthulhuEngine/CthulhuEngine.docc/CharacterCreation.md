# Character Creation

Apply creation-time caps and allocate points to skills.

## Creation Cap

Set a sheet-wide maximum for skills during creation:

```swift
var sheet = CharacterSheet(name: "Investigator")
sheet.setCreationSkillCap(75)
```

## Adding Points

Use helper methods to add points, clamped by the cap:

```swift
// Using SkillType
sheet.setSkill(.spotHidden)               // base 25
sheet.addToSkill(.spotHidden, amount: 100) // => 75 (capped)

// Named custom skill with per-call cap override
sheet.addToSkill(named: "Custom Skill", amount: 120, cap: 60) // => 60
```

## Notes

- Creation cap only applies to the add helpers; it does not affect in-play improvements.
- Improvement checks have their own cap parameter (default 99) and rules.

