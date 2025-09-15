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
        // With DB +2, knife is 1d4+2 => 3..6
        let r = knife.rollDamage(context: .init(damageBonus: 2))
        #expect(3...6 ~= r.value)
        #expect(r.input == "1d4+{DB}")
        #expect(r.resolved.contains("1d4+2"))
    }

    @Test func genericHandgunRange() {
        let pistol = WeaponsCatalog.handgun
        let r = pistol.rollDamage()
        #expect(1...10 ~= r.value)
    }
}
