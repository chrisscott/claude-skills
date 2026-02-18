# Claude Skills

A collection of [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skills for app development workflows.

## Available Skills

| Skill | Description |
|-------|-------------|
| [ios-app-builder](skills/ios-app-builder/) | Guides you through building an iOS app from scratch — planning, Liquid Glass UI, accessibility, testing, App Store submission |

## Installation

### Option 1: Load directly (quickest)

Clone the repo and pass it to Claude Code with `--plugin-dir`:

```bash
git clone https://github.com/chrisscott/claude-skills.git
claude --plugin-dir ./claude-skills
```

Skills are available immediately. Claude will invoke them when relevant, or you can use them directly via `/claude-skills:ios-app-builder`.

### Option 2: Add as a marketplace

Inside a Claude Code session, add this repo as a plugin marketplace, then install from it:

```
/plugin marketplace add chrisscott/claude-skills
/plugin install ios-app-builder@claude-skills
```

See the [Claude Code plugins docs](https://code.claude.com/docs/en/discover-plugins) for more details.

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
