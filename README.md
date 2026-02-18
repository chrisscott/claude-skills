# Claude Skills

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) plugin marketplace for app development workflows.

## Available Plugins

| Plugin | Description |
|--------|-------------|
| [ios-app-builder](plugins/ios-app-builder/) | Guides iOS app development from planning through App Store submission — Liquid Glass UI, accessibility, automated screenshots, and more |

## Installation

Add the marketplace and install plugins:

```
/plugin marketplace add chrisscott/claude-skills
/plugin install ios-app-builder@claude-skills
```

Or for local development:

```bash
claude --plugin-dir ./plugins/ios-app-builder
```

See the [Claude Code plugin docs](https://code.claude.com/docs/en/discover-plugins) for more details.

## ios-app-builder

An end-to-end iOS development assistant that covers:

- **Planning** — project setup, iOS 26 Liquid Glass design, accessibility from day one, App Store metadata tracking
- **Building** — incremental builds, automated screenshot capture, test strategy, sample data management
- **Debugging** — CLI-based debugging with `xcodebuild`, `xcrun simctl`, and simulator tools
- **App Store submission** — metadata character limits, screenshot specs, submission checklist

Includes reference docs for the Liquid Glass SwiftUI API, App Store Connect field requirements, and a screenshot automation script.

## License

MIT
