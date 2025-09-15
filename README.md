# CthulhuEngine

[![Build](https://github.com/alanquatermain/cthulhu-engine/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/alanquatermain/cthulhu-engine/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/alanquatermain/cthulhu-engine/branch/main/graph/badge.svg)](https://codecov.io/gh/alanquatermain/cthulhu-engine)
[![Docs](https://img.shields.io/badge/docs-DocC-blue?logo=swift)](https://alanquatermain.github.io/cthulhu-engine)
![Swift 6.2](https://img.shields.io/badge/Swift-6.2-orange?logo=swift)
[![Release](https://img.shields.io/github/v/release/alanquatermain/cthulhu-engine?include_prereleases)](https://github.com/alanquatermain/cthulhu-engine/releases)

A lightweight Swift library for Call of Cthulhu (7e) character sheets, skills, attributes, inventory, weapons, and d100 tests powered by DiceRoller.

- Attributes and thresholds (STR/CON/DEX/APP/POW/SIZ/INT/EDU)
- Skills with default bases and success levels (regular/hard/extreme)
- Advantage/disadvantage d100 via expression strings
- Mark-on-success and improvement checks (with caps and exceptions)
- Character creation helpers: skill caps and add-to-skill utilities
- Weapons and damage (melee and firearms), damage bonus from STR+SIZ, impales
- Cover and range rules with a simple attack API
- DocC documentation and a script to generate docs locally

Documentation website (DocC): https://alanquatermain.github.io/cthulhu-engine

## Requirements

- Swift 6.2 or later (package manifest uses swift-tools-version: 6.2)
- Swift Package Manager (SPM)

## Installation (Swift Package Manager)

Add the package dependency to your `Package.swift`:

```swift
// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "YourApp",
    platforms: [
        .macOS(.v13), .iOS(.v16)
    ],
    dependencies: [
        .package(url: "https://github.com/alanquatermain/cthulhu-engine.git", branch: "main")
    ],
    targets: [
        .target(
            name: "YourApp",
            dependencies: [
                .product(name: "CthulhuEngine", package: "cthulhu-engine")
            ]
        )
    ]
)
```

Then import the module:

```swift
import CthulhuEngine
```

## Quick Start

### Create a Character

```swift
var sheet = CharacterSheet(name: "Investigator")

// Set attributes
sheet.setAttribute(.dex, value: 60)
sheet.setAttribute(.edu, value: 70)
sheet.setAttribute(.str, value: 80)
sheet.setAttribute(.siz, value: 55)

// Add predefined skills (base values applied automatically)
sheet.setSkill(.spotHidden)      // base 25
sheet.setSkill(.dodge)           // base DEX/2 => 30
sheet.setSkill(.languageOwn)     // base EDU   => 70

// Add a custom skill
sheet.setSkill(Skill(name: "Archaeobotany", value: 5, base: 5))
```

### Roll Skills (d100)

```swift
// Normal
if let r = sheet.testSkill(named: "Spot Hidden") {
    print("d% =", r.roll, r.success) // regular/hard/extreme/critical/failure/fumble
}

// Advantage / Disadvantage
_ = sheet.testSkill(named: "Spot Hidden", mode: .advantage)
_ = sheet.testSkill(named: "Spot Hidden", mode: .disadvantage)

// Disable marking on success for this roll (defaults to true)
_ = sheet.testSkill(named: "Spot Hidden", markOnSuccess: false)
```

### Attribute Checks

```swift
let powCheck = sheet.testAttribute(.pow)
print(powCheck.success)
```

### Improvements

```swift
// Skills mark themselves on regular-or-better success (by default)
_ = sheet.testSkill(named: "Spot Hidden")

// Later, perform improvement checks (cap defaults to 99)
let results = sheet.performImprovementChecks()
for r in results {
    print("\(r.name): \(r.before) -> \(r.after) +\(r.gained)")
}
```

### Character Creation Helpers

```swift
// Set a creation-time cap and allocate points
sheet.setCreationSkillCap(75)
sheet.setSkill(.spotHidden)                // base 25
sheet.addToSkill(.spotHidden, amount: 100) // -> 75 (capped)

// Named skill with per-call cap override
sheet.addToSkill(named: "Custom Skill", amount: 120, cap: 60) // -> 60
```

## Weapons, Damage, and Combat

### Damage Bonus and Build

```swift
let dbExpr = sheet.damageBonusExpression() // e.g., "1d4"
let build  = sheet.buildValue()            // -2 .. +5
let ctx    = sheet.damageContext()         // DamageContext with DB
```

### Roll Weapon Damage

```swift
let knife = WeaponsCatalog.knife
let dmg   = knife.rollDamage(context: ctx)
print(dmg.resolved, dmg.value)

// Impale (extreme success with impaling weapon)
let impaled = knife.rollDamage(context: .init(damageBonusExpression: "0"), impale: true)
```

### Cover and Range

Use `AttackOptions` to account for range, cover, size, aiming, bracing, and movement.

```swift
let rifle = WeaponsCatalog.rifle303
var options = AttackOptions(rangeYards: 150, cover: .light, targetSize: .normal, aimed: true)

if let attack = sheet.performAttack(weapon: rifle, using: .firearmsRifleShotgun, options: options) {
    print(attack.test.success, attack.damage?.value as Any, attack.impaled)
}
```

- Mode aggregation (advantage/disadvantage) is derived from `AttackOptions`.
- Minimum success difficulty is enforced based on weapon range profile and cover.
- Hard cover nullifies non-impaling hits.

## Documentation

- Online docs: https://alanquatermain.github.io/cthulhu-engine
- Generate DocC locally (requires the swift-docc plugin in Package.swift):

```bash
# Default local docs (no static hosting transform)
./Scripts/generate-docs.sh

# For static hosting (e.g., GitHub Pages) with a base path
./Scripts/generate-docs.sh --static-hosting CthulhuEngine
```

The generated site is written to the `Documentary/` folder at the repo root (ignored by git).

## Testing and Coverage

```bash
swift test --enable-code-coverage

# Example coverage report on macOS (adjust path as needed)
xcrun llvm-cov report \
  .build/debug/CthulhuEnginePackageTests.xctest/Contents/MacOS/CthulhuEnginePackageTests \
  -instr-profile .build/debug/codecov/default.profdata
```

## Notes

- Dice expressions are evaluated via the DiceRoller package.
- Advantage/disadvantage d100 use:
  - Normal: `d%`
  - Advantage: `(2d10kh1)*10+1d10`
  - Disadvantage: `(2d10dh1)*10+1d10`
- Some advanced rules (automatic fire, recoil, specific tables per era) can be added next; the API is designed to be extended.

## License

This project is distributed under terms specified by the repository owner. See the repository for license information once published.
