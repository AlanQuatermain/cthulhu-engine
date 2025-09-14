import Testing
@testable import CthulhuEngine

@Suite struct AttributesSuite {
    @Test func namesAndCodes() {
        #expect(Attribute.str.code == "STR")
        #expect(Attribute.str.fullName == "Strength")
        #expect(Attribute.dex.fullName == "Dexterity")
        #expect(Attribute.int.fullName == "Intelligence")
        #expect(Attribute.edu.fullName == "Education")
    }

    @Test func thresholds() {
        let t = AttributeThresholds(value: 70)
        #expect(t.half == 35)
        #expect(t.fifth == 14)
    }
}

