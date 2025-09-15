# Build a Character

Create an investigator with attributes, core skills, and inventory.

## Create a Sheet and Set Attributes

Set up a `CharacterSheet` and define core characteristics.

```swift
import CthulhuEngine

var sheet = CharacterSheet(name: "Investigator")
sheet.setAttribute(.str, value: 60)
sheet.setAttribute(.dex, value: 55)
sheet.setAttribute(.edu, value: 70)
```

Add predefined skills. Base values are applied automatically.

```swift
sheet.setSkill(.spotHidden)       // base 25
sheet.setSkill(.dodge)            // base DEX/2 => 27
sheet.setSkill(.languageOwn)      // base EDU   => 70
```

## Add Inventory

Track items the investigator carries.

```swift
sheet.inventory.add(Item(name: "Flashlight"))
sheet.inventory.add(Item(name: "Notebook", quantity: 1, notes: "Clues"))
```
