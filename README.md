# Claude Skills

A collection of [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skills for app development workflows.

## Available Skills

| Skill | Description |
|-------|-------------|
| [ios-app-builder](skills/ios-app-builder/) | Guides you through building an iOS app from scratch — planning, Liquid Glass UI, accessibility, testing, App Store submission |

## Installation

Install this plugin in Claude Code:

```bash
claude plugin add --git https://github.com/chrisscott/claude-skills
```

Once installed, the skills are automatically available. Claude will invoke them when relevant, or you can use them directly via `/ios-app-builder`.

## What's Included

### ios-app-builder

An end-to-end iOS development assistant that covers:

- **Planning** — project setup, iOS 26 Liquid Glass design, accessibility from day one, App Store metadata tracking
- **Building** — incremental builds, automated screenshot capture, test strategy, sample data management
- **Debugging** — CLI-based debugging with `xcodebuild`, `xcrun simctl`, and simulator tools
- **App Store submission** — metadata character limits, screenshot specs, submission checklist

Includes reference docs for the Liquid Glass SwiftUI API, App Store Connect field requirements, and a screenshot automation script.

## License

MIT
