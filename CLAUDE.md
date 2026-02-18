# Claude Skills

A collection of Claude Code skills (plugins) for app development workflows.

## Repository Structure

```
claude-skills/
├── .claude-plugin/          # Plugin metadata
│   └── plugin.json
└── skills/
    └── <skill-name>/
        ├── SKILL.md         # Skill definition (required)
        ├── references/      # Reference docs the skill reads
        └── scripts/         # Automation scripts
```

## Conventions

- Each skill lives in `skills/<skill-name>/SKILL.md`
- Skills use YAML frontmatter with `name`, `description`, and optionally `allowed-tools`
- Reference materials go in `references/` — these are read by the skill at runtime
- Scripts go in `scripts/` — must be executable
- Keep SKILL.md focused on instructions; move detailed reference data to `references/`

## iOS Development Guidelines

When working on iOS skills or iOS projects using these skills:

- **Target iOS 26+** with Liquid Glass design system
- **SwiftUI only** — no UIKit unless absolutely required for missing SwiftUI API
- **Swift 6** strict concurrency
- **Accessibility is mandatory from the start** — VoiceOver labels, Dynamic Type, reduced motion/transparency support on every view
- **Glass is for navigation, not content** — apply `.glassEffect()` to bars, toolbars, FABs; never to list rows or content areas
- **Build frequently** — run `xcodebuild build` after changes to catch errors early
- **Test meaningfully** — unit tests for logic, UI tests for flows + screenshots, accessibility audits
- **Automate screenshots** — use UI tests with `XCTAttachment` and the capture script
- **Track App Store metadata** — maintain `AppStoreConnect.md` in project root from day one
