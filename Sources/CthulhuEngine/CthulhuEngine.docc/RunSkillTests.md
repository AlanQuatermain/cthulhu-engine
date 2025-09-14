@Tutorial(time: 5, projectFiles: []) {
  @Intro(title: "Run Skill Tests") {
    Perform d100 tests with advantage/disadvantage and interpret results.
  }

  @Section(title: "Roll d100 for Skills and Attributes") {
    Use expression-based rolls via DiceRoller under the hood.

    @Steps {
      @Step {
        Run a normal Spot Hidden roll.
        ```swift
        if let r = sheet.testSkill(named: "Spot Hidden") {
          print(r.roll, r.success)
        }
        ```
      }
      @Step {
        Use advantage or disadvantage as needed.
        ```swift
        _ = sheet.testSkill(named: "Spot Hidden", mode: .advantage)
        _ = sheet.testSkill(named: "Spot Hidden", mode: .disadvantage)
        ```
      }
      @Step {
        Try an attribute check.
        ```swift
        let powCheck = sheet.testAttribute(.pow)
        print(powCheck.success)
        ```
      }
    }
  }

  @Section(title: "Mark on Success") {
    Marking is enabled by default; disable it per roll if required.

    ```swift
    _ = sheet.testSkill(named: "Spot Hidden", markOnSuccess: false)
    ```
  }
}

