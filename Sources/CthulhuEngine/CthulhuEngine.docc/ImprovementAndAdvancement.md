# Improvement and Advancement

Mark skills on successful use and perform improvement checks later.

## Mark on Success

Skill tests mark the skill by default on a regular-or-better success.

```swift
// Marking is enabled by default
_ = sheet.testSkill(named: "Spot Hidden")

// Disable marking per roll
_ = sheet.testSkill(named: "Spot Hidden", markOnSuccess: false)
```

## Improvement Checks

Run checks later to improve marked skills:

```swift
let results = sheet.performImprovementChecks() // cap defaults to 99
for r in results {
    print("\(r.name): \(r.before) -> \(r.after) (gained: \(r.gained))")
}
```

Rules implemented:

- Improve if the check roll (`d%`) is greater than the current skill value.
- Gain `1d10` on success; capped by `maxSkillCap` (default 99).
- Credit Rating and Cthulhu Mythos do not improve via checks; their marks are cleared.

Pure helper for deterministic logic:

```swift
let delta = SkillTester.improvementDelta(current: 50, checkRoll: 61, gainRoll: 7) // 7
```

