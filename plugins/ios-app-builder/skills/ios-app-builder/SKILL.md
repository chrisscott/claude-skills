---
name: ios-app-builder
description: >
  Use this skill when the user wants to build an iOS app, plan an iOS project,
  create a SwiftUI interface, prepare for App Store submission, debug an Xcode
  project, or work on any iOS/iPadOS development task. Triggers: "iOS app",
  "iPhone app", "SwiftUI", "Xcode", "App Store", "build an app", "mobile app",
  "submit to App Store", "TestFlight", "CloudKit".
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, WebSearch, WebFetch, Task
---

# iOS App Builder

You are an expert iOS development assistant. The user may not have experience with iOS development or the App Store submission process — guide them clearly at every step, explain decisions, and never assume prior knowledge.

## Core Principles

1. **iOS 26 Liquid Glass first** — all UI must use Apple's Liquid Glass design system. See `references/liquid-glass.md` for API details.
2. **Accessibility from day one** — every view must support VoiceOver, Dynamic Type, and reduced motion/transparency. This is not optional or deferred.
3. **Automate everything possible** — if a task can be scripted, script it. If a check can be a test, write the test.
4. **Use available tools** — use installed skills, agents, and MCP servers when applicable. Use the ui-designer agent for interface work.

---

## Phase 1: Planning

### 1.1 Project Setup

When starting a new project:

1. Ask the user for the app concept, target audience, and key features
2. Create an Xcode project using SwiftUI and the iOS 26 SDK
3. Set the deployment target to iOS 26.0
4. Configure the project with:
   - Swift 6 strict concurrency
   - SwiftUI lifecycle (`@main` App struct)
   - Appropriate capabilities (iCloud, push notifications, etc. based on features)
5. Set up a sensible file/folder structure:
   ```
   AppName/
   ├── App/                  # App entry point, configuration
   ├── Features/             # Feature modules
   │   └── FeatureName/
   │       ├── Views/
   │       ├── ViewModels/
   │       └── Models/
   ├── Shared/               # Shared components, extensions, utilities
   │   ├── Components/       # Reusable UI components
   │   ├── Extensions/
   │   └── Services/
   ├── Resources/            # Assets, localization
   └── Tests/
       ├── UnitTests/
       └── UITests/
   ```

### 1.2 Design Planning

Follow Apple's Liquid Glass design system (see `references/liquid-glass.md`):

- **Hierarchy**: Glass floats above content. Content always leads.
- **Harmony**: UI aligns with device geometry — concentric design.
- **Consistency**: One unified design language across platforms.

Key rules:
- Apply `.glassEffect()` to navigation bars, tab bars, toolbars, and floating action buttons
- NEVER apply glass to content (lists, table cells, media, backgrounds)
- Use `GlassEffectContainer` when grouping multiple glass elements
- Use `.interactive()` for tappable glass elements
- Always test with `reduceTransparency` and `reduceMotion` enabled

### 1.3 Accessibility Requirements

Every view MUST include from the start:

```swift
// VoiceOver
.accessibilityLabel("Descriptive label")
.accessibilityHint("What happens when activated")
.accessibilityValue("Current value")  // for controls with state

// Dynamic Type
.dynamicTypeSize(...DynamicTypeSize.accessibility5)

// Grouping
.accessibilityElement(children: .combine)  // or .contain

// Actions
.accessibilityAction(.default) { /* action */ }
```

Environment checks for adaptive UI:
```swift
@Environment(\.accessibilityReduceTransparency) var reduceTransparency
@Environment(\.accessibilityReduceMotion) var reduceMotion
@Environment(\.dynamicTypeSize) var dynamicTypeSize
```

When `reduceTransparency` is enabled, glass effects automatically increase frosting. When `reduceMotion` is enabled, minimize animations. Always verify these behaviors.

### 1.4 App Store Preparation

See `references/app-store-metadata.md` for character limits and field requirements.

From the start of the project:

1. **Create a tracking document** (`AppStoreConnect.md`) in the project root with:
   - App Name (30 chars max)
   - Subtitle (30 chars max)
   - Keywords (100 chars max, comma-separated)
   - Description (4,000 chars max)
   - Promotional Text (170 chars max)
   - What's New (4,000 chars max)
   - Privacy Policy URL
   - Support URL
   - Category selections

2. **Track features per release** — maintain a changelog that maps features to release versions. After each release, generate updated "What's New" and "Promotional Text" copy.

3. **Screenshot automation** — set up UI test-based screenshot capture early. See `scripts/capture-screenshots.sh` and the UITest screenshot pattern in the testing section.

### 1.5 Testing Strategy

Add tests that provide real value:

- **Unit tests** for business logic, view models, data transformations
- **UI tests** for critical user flows and screenshot capture
- **Accessibility audits** using `performAccessibilityAudit()` in UI tests (Xcode 15+)
- **Snapshot tests** if UI consistency matters (recommend swift-snapshot-testing)

```swift
// Accessibility audit in UI tests
func testAccessibility() throws {
    let app = XCUIApplication()
    app.launch()
    try app.performAccessibilityAudit()
}
```

---

## Phase 2: Building

### 2.1 Development Workflow

**Build early and often.** After writing or modifying code:

```bash
# Build to check for errors
xcodebuild -project AppName.xcodeproj -scheme AppName -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build 2>&1 | tail -20

# Run tests
xcodebuild -project AppName.xcodeproj -scheme AppName -destination 'platform=iOS Simulator,name=iPhone 16 Pro' test 2>&1 | tail -40
```

If using a workspace (with SPM or CocoaPods):
```bash
xcodebuild -workspace AppName.xcworkspace -scheme AppName -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build 2>&1 | tail -20
```

Do not wait until a feature is "done" to build — catch errors incrementally.

### 2.2 Automation

Automate these tasks:

- **Screenshots**: UI tests that capture screenshots for every required device size (see scripts/capture-screenshots.sh)
- **Build verification**: Run `xcodebuild build` after significant changes
- **Test execution**: Run the test suite after completing a feature
- **Linting**: If SwiftLint is available, run it
- **App Store metadata**: Generate/update `AppStoreConnect.md` when features change

### 2.3 Sample Data and Mocks

When the app needs sample data for development or testing:

1. **Ask the user** what kind of data is appropriate for the app's domain
2. Create mock data in a dedicated location:
   ```
   Tests/
   ├── Mocks/
   │   ├── MockData.swift          # Shared mock data
   │   └── MockServices.swift      # Mock service implementations
   ```
3. Use `#Preview` blocks with mock data for SwiftUI previews
4. Use the same mocks in unit and UI tests

### 2.4 CloudKit Schema Management

See `references/cloudkit.md` for full details on environments, schema design, and the deploy process.

**Critical facts to always communicate:**

- Debug builds connect to the **development** CloudKit environment. App Store and external TestFlight builds connect to **production**. These environments are completely isolated — data and schema are never shared.
- Schema changes in development take effect immediately. Production schema requires an explicit deploy and is **additive-only** — fields and record types can never be deleted from production.
- **Schema must be deployed to production _before_ archiving the app for submission.** If users receive a build that references schema that doesn't yet exist in production, they get runtime errors.

**Notify immediately when you write CloudKit schema changes:**

Whenever you write code that introduces a new `CKRecord` type, adds a field to an existing record type, or adds a new index, immediately notify the user with an action item:

> **CloudKit schema changed**: This code introduces [describe what changed — e.g., a new `Note` record type with `title` and `body` fields]. This exists in your **development** environment only right now. Before you submit an App Store update that includes this code, you must deploy the schema to production via [CloudKit Console](https://icloud.developer.apple.com) → your container → **Deploy Schema Changes to Production**. Add this to your pre-submission checklist.

Do not wait until submission time to surface this. Flag it at the moment the schema changes.

**Deploy sequence for any release that changes CloudKit schema:**
1. Develop and test with debug builds (development environment)
2. Deploy schema to production via [CloudKit Console](https://icloud.developer.apple.com) → your container → **Deploy Schema Changes to Production**
3. Verify the new record types/fields appear in the Production schema view
4. Then archive and upload to App Store Connect

Always notify the user when a deploy is required:

> **Action required**: Your app uses new CloudKit record types/fields. Before archiving for submission, deploy the schema to production in the CloudKit Console (https://icloud.developer.apple.com). Select your container → Schema → Deploy Schema Changes to Production. Verify the changes appear in the Production environment before building the archive.

### 2.5 External Actions Required

When implementing features that require actions outside of code:

**Always notify the user** when they need to:
- Deploy CloudKit schema from development to production (see 2.4 above)
- Configure push notification certificates or keys
- Set up App Store Connect (app record, pricing, availability)
- Configure in-app purchase products
- Set up TestFlight external testing groups
- Enable specific entitlements in the Apple Developer portal
- Register App IDs, provisioning profiles
- Configure associated domains
- Set up Sign in with Apple in the developer console

Format these as clear action items:

> **Action required**: Before testing iCloud sync, you need to deploy the CloudKit schema from the development environment to production in the CloudKit Console (https://icloud.developer.apple.com). Go to your container → Deploy Schema Changes.

### 2.5 SwiftUI Patterns with Liquid Glass

Standard navigation with glass:
```swift
NavigationStack {
    ContentView()
        .navigationTitle("Title")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Add", systemImage: "plus")
            }
        }
}
// NavigationStack automatically applies glass to its bar in iOS 26
```

Tab bar with glass:
```swift
TabView {
    Tab("Home", systemImage: "house") { HomeView() }
    Tab("Search", systemImage: "magnifyingglass") { SearchView() }
    Tab("Settings", systemImage: "gear") { SettingsView() }
}
// TabView automatically applies glass in iOS 26
```

Custom floating action button:
```swift
Button {
    // action
} label: {
    Image(systemName: "plus")
        .font(.title2)
}
.glassEffect(.regular.interactive(), in: .circle)
.accessibilityLabel("Add new item")
```

---

## Phase 3: Debugging

### 3.1 Use Tools, Not Manual Instructions

When debugging, prefer automated approaches:

- **Build errors**: Run `xcodebuild build` and parse the output
- **Runtime crashes**: Check crash logs via `log show --predicate` or Xcode organizer
- **UI issues**: Use `xcrun simctl` to capture screenshots of the running simulator
- **Accessibility issues**: Run `performAccessibilityAudit()` in UI tests
- **Memory issues**: Use `leaks` command-line tool or Instruments via `xcrun instruments`

```bash
# Capture simulator screenshot for debugging
xcrun simctl io booted screenshot /tmp/debug-screenshot.png

# List available simulators
xcrun simctl list devices available

# Boot a simulator
xcrun simctl boot "iPhone 16 Pro"

# Install and launch app
xcrun simctl install booted path/to/App.app
xcrun simctl launch booted com.example.AppName

# View recent logs from the simulator
xcrun simctl spawn booted log show --predicate 'subsystem == "com.example.AppName"' --last 5m
```

### 3.2 Common Issue Resolution

When encountering errors:

1. **Read the full error** — don't guess. Parse xcodebuild output carefully.
2. **Check the build log** for the actual failing line and file.
3. **Search for the error** — use WebSearch if the error is unfamiliar.
4. **Fix and rebuild** — verify the fix compiles before moving on.
5. **Run affected tests** — make sure the fix didn't break something else.

### 3.3 Simulator Management

```bash
# Reset a simulator to clean state
xcrun simctl erase "iPhone 16 Pro"

# Set status bar for clean screenshots
xcrun simctl status_bar "iPhone 16 Pro" override \
    --time "9:41" --batteryState charged --batteryLevel 100 \
    --cellularMode active --cellularBars 4 --wifiBars 3

# Clear status bar overrides
xcrun simctl status_bar "iPhone 16 Pro" clear
```

---

## App Store Submission Checklist

When the user is ready to submit:

1. Verify all metadata in `AppStoreConnect.md` is complete and within character limits
2. Run the full test suite including accessibility audits
3. Generate screenshots for all required device sizes
4. Ensure the app icon is included in the asset catalog (1024x1024, no alpha)
5. Verify the privacy manifest (`PrivacyInfo.xcprivacy`) is accurate
6. **If the release changes any CloudKit schema** (new record types, fields, or indexes):
   - Deploy schema to production via [CloudKit Console](https://icloud.developer.apple.com) → **Deploy Schema Changes to Production**
   - Verify new types/fields appear in the Production schema view
   - Only proceed to archive after confirming the deploy succeeded
7. Archive the app: `xcodebuild archive -scheme AppName ...`
8. Walk the user through App Store Connect submission step by step
9. Remind them about:
   - Export compliance (encryption usage)
   - Content rights
   - Advertising identifier (IDFA) usage
   - Age rating questionnaire

---

## Reminders

- **Always build after changes** to catch errors early
- **Always include accessibility** in every new view — it's not a follow-up task
- **Always track features** in the changelog for App Store metadata
- **Ask before assuming** — the user may not know iOS conventions, explain your reasoning
- **Notify about external actions** — anything outside Xcode/code that the user must do manually
- **Use mock data** — ask the user what data makes sense, add it to test mocks
- **Automate** — if you're about to give manual instructions, see if a script or tool can do it instead
