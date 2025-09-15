import Testing
@testable import CthulhuEngine

@Suite struct WeaponsSuite {
    @Test func unarmedAndKnifeDamageRanges() {
        let db0 = DamageContext(damageBonus: nil)
        let unarmed = WeaponsCatalog.unarmedBrawl
        let u = unarmed.rollDamage(context: db0)
        #expect(1...3 ~= u.value)

        let knife = WeaponsCatalog.knife
        let k = knife.rollDamage(context: db0)
        #expect(1...4 ~= k.value)
    }

    @Test func damageBonusSubstitution() {
        let knife = WeaponsCatalog.knife
        // With DB 1d4, knife is 1d4+1d4 => 2..8
        let r = knife.rollDamage(context: .init(damageBonusExpression: "1d4"))
        #expect(2...8 ~= r.value)
        #expect(r.input == "1d4+{DB}")
        #expect(r.resolved.contains("1d4+1d4"))
    }

    @Test func genericHandgunRange() {
        let pistol = WeaponsCatalog.handgun
        let r = pistol.rollDamage()
        #expect(1...10 ~= r.value)
    }

    @Test func knifeImpaleAddsMaxPlusRoll() {
        let knife = WeaponsCatalog.knife
        // DB 0, impale => 4 + 1d4 => 5..8
        let r = knife.rollDamage(context: .init(damageBonusExpression: "0"), impale: true)
        #expect(5...8 ~= r.value)
        #expect(r.input.contains("4+1d4"))
    }
}
