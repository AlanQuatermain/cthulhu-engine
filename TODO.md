## CthulhuEngine – Next Steps

### Core Rules
- Opposed/resistance rolls (e.g., STR vs STR, POW vs POW) with outcome mapping.
- Push rolls and Luck spends; Luck recovery and spends on damage/rolls.
- Sanity (SAN) checks, temporary/indefinite insanity, treatment, and recovery.
- Chases, pursuits, and spot rules (grappling, maneuvers, surprise, initiative variants).

### Weapons & Combat
- Automatic/burst fire, recoil, and rate-of-fire penalties; ammo tracking.
- Armor/cover DR and armor-piercing traits; shotguns by range with spread rules.
- Called shots, prone/aimed/braced modifiers; target size tables per era.
- Wider 1920s/1940s weapon catalogs from published tables; JSON-driven catalogs.

### Characters & Progression
- Occupations with skill packages, Credit Rating ranges, and starting points.
- Background elements (ideology/significant people/meaningful locations/traits).
- Skill specialties (e.g., Languages, Sciences) with consistent naming + UI helpers.
- Improvement cadence and constraints (once per scenario/session, clear flags policy).

### Data & Extensibility
- External data format (JSON/TOML) for skills, weapons, occupations, house rules.
- Rule profiles (Classic/Pulp/House) with pluggable modifiers and calculators.
- Seeded RNG option for deterministic tests/docs while keeping DiceRoller core.

### API & Tooling
- Public API audit and semantic versioning; deprecations with guidance.
- Swift Package Index metadata and doc links; SPI build badges.
- Lint/format (SwiftLint/SwiftFormat), access control tightening, Sendable audit.
- CLI tool (optional) for quick rolls, character summaries, and damage calc.

### Docs & Testing
- True DocC tutorials (.tutorial files) with assets; expand articles with examples.
- Property-based tests for success classification and improvement math.
- Snapshot/fixture tests for catalogs; fuzz tests for dice expression resolution.
- Coverage thresholds in CI; platform matrix (macOS/iOS) builds.
