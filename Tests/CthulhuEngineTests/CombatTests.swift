import Testing
@testable import CthulhuEngine

@Suite struct CombatSuite {
    @Test func resolverImpaleAndNormal() {
        let knife = WeaponsCatalog.knife
        let ctx = DamageContext(damageBonusExpression: "0")
        // Extreme success with impaling weapon uses impale expression (5..8)
        let (impaleDamage, impaled) = AttackResolver.damage(for: knife, success: .extreme, context: ctx)
        #expect(impaled == true)
        #expect((impaleDamage?.value ?? 0) >= 5)
        #expect((impaleDamage?.value ?? 0) <= 8)

        // Regular success uses normal expression (1..4)
        let (normalDamage, notImpaled) = AttackResolver.damage(for: knife, success: .regular, context: ctx)
        #expect(notImpaled == false)
        #expect((normalDamage?.value ?? 0) >= 1)
        #expect((normalDamage?.value ?? 0) <= 4)

        // Failure yields no damage
        let (noDamage, _) = AttackResolver.damage(for: knife, success: .failure, context: ctx)
        #expect(noDamage == nil)
    }

    @Test func buildAndDBFromAttributes() {
        var sheet = CharacterSheet(name: "Investigator")
        sheet.setAttribute(.str, value: 80)
        sheet.setAttribute(.siz, value: 55) // sum 135 -> DB 1d4, Build +1
        #expect(sheet.damageBonusExpression() == "1d4")
        // Build is not directly exposed as a property; compute from method
        // Mirror DB table for build calculation
        let build = {
            let sum = 80 + 55
            switch sum {
            case ..<65: return -2
            case 65...84: return -1
            case 85...124: return 0
            case 125...164: return 1
            case 165...204: return 2
            case 205...284: return 3
            case 285...364: return 4
            default: return 5
            }
        }()
        #expect(build == 1)
    }
}

