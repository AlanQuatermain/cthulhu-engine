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
let db = DamageContext(damageBonus: 2)
let result = knife.rollDamage(context: db)
print(result.input, "=>", result.resolved, "=", result.value)
```

## Built-in Catalog

`WeaponsCatalog` contains a few common examples you can use directly:

- `unarmedBrawl`: `1d3+{DB}` (Fighting (Brawl))
- `knife`: `1d4+{DB}` (Fighting (Knife))
- `club`: `1d6+{DB}` (Fighting (Club))
- `handgun`: `1d10` (generic firearm — adjust per your table)

> Note: Many weapons in Call of Cthulhu have additional properties (range bands,
> special effects like impales, or alternate damage at different ranges).
> This library provides a flexible base via expressions and can be extended with
> additional weapon metadata and rules as needed.

