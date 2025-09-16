## Agent Notes

- Next session: Convert TODO.md items into GitHub issues and organize them into milestones (e.g., Core Rules, Combat, Data/Extensibility, Docs/Testing). Propose priorities and rough sizing for each issue.
- Keep README badges and workflows in sync (build, coverage, docs). If coverage drops, suggest thresholds or targeted tests.
- When bumping Swift tools to 6.2, update Package.swift + README, and consider conditional dependency selection for `swift-testing` as outlined.
- For docs, consider migrating current articles into proper DocC tutorials (`.tutorial` files) with assets once structure is agreed.
- Before large changes, run `swift test --enable-code-coverage` locally and regenerate docs via `./Scripts/generate-docs.sh` to catch regressions and doc warnings early.
