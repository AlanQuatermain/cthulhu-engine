# Weapons and Damage

Model weapons with damage expressions and roll for damage using DiceRoller.

## Defining Weapons

Use `Weapon` with a `WeaponDamage` expression. You can reference variables
like `{DB}` (damage bonus) that will be substituted with numeric values
before rolling.

```swift
let knife = Weapon(name: "Knife", damage: .init(expression: "1d4+{DB}"), skill: .fighting(specialization: "Knife"))
```

## Rolling Damage

Provide a `DamageContext` when rolling to supply variables such as damage bonus:

```swift
let db = DamageContext(damageBonusExpression: "1d4")
let result = knife.rollDamage(context: db)
print(result.input, "=>", result.resolved, "=", result.value)
```

## Built-in Catalog

`WeaponsCatalog` contains a few common examples you can use directly:

- `unarmedBrawl`: `1d3+{DB}` (Fighting (Brawl))
- `knife`: `1d4+{DB}` (Fighting (Knife))
- `club`: `1d6+{DB}` (Fighting (Club))
- `handgun`: `1d10` (generic firearm — adjust per your table)

### Impales

For impaling weapons (e.g., `knife`), you can set `isImpaling: true` and provide
an `impaleExpression` (e.g., `"4+1d4+{DB}"`) to roll on an impale result:

```swift
let r = knife.rollDamage(context: .init(damageBonusExpression: "0"), impale: true)
```

### Damage Bonus from Attributes

Compute a damage bonus expression from STR+SIZ:

```swift
let dbExpr = sheet.damageBonusExpression() // e.g., "1d4"
let ctx = sheet.damageContext()            // DamageContext(damageBonusExpression: dbExpr)
let dmg = knife.rollDamage(context: ctx)

### Resolving Attacks

Use `performAttack(weapon:using:mode:markOnSuccess:)` to roll the skill and
resolve damage in one call. Extreme successes with impaling weapons use the
impale expression.

```swift
if let result = sheet.performAttack(weapon: WeaponsCatalog.knife, using: .fightingBrawl) {
  print(result.test.success, result.damage?.value as Any, result.impaled)
}
```

> Note: Many weapons in Call of Cthulhu have additional properties (range bands,
> special effects like impales, or alternate damage at different ranges).
> This library provides a flexible base via expressions and can be extended with
> additional weapon metadata and rules as needed.
