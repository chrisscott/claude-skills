# Liquid Glass Design Reference (iOS 26)

## Overview

Liquid Glass is Apple's design system introduced with iOS 26 at WWDC 2025. It features dynamic translucent materials that mimic real glass with refraction, specular highlights, and motion responsiveness.

## Three Foundational Principles

### Hierarchy
- Controls float above content using glass layers
- Content always leads — glass is the functional navigation layer, not decoration
- Tab bars shrink when scrolling to focus on content, expand when scrolling back

### Harmony
- UI elements align with the device's rounded geometry (concentric design)
- Curvature, size, and proportion create rhythm between hardware and software

### Consistency
- One unified design system across iOS, iPadOS, macOS, watchOS, tvOS, and visionOS
- Adaptive geometry allows elements to work across devices and window sizes

## Where to Apply Glass

**YES — Navigation layer:**
- Navigation bars
- Tab bars
- Toolbars
- Floating action buttons
- Overlaid controls
- Widgets and app icons

**NO — Content layer:**
- List rows or table cells
- Content areas
- Background surfaces
- Applying glass to all list rows creates overused, confusing UI

## SwiftUI API

### Core Modifier

```swift
.glassEffect(_ glass: Glass = .regular, in shape: Shape = DefaultGlassEffectShape, isEnabled: Bool = true)
```

### Glass Variants

| Variant | Use Case |
|---------|----------|
| `Glass.regular` | Default — medium transparency, full adaptivity |
| `Glass.clear` | High transparency for media-rich backgrounds (requires dimming layer) |
| `Glass.identity` | No effect — used for conditional disabling |

`.clear` only for elements that meet ALL three requirements:
1. Media-rich background positioning
2. Non-negative content impact
3. Bold/bright foreground content

### Instance Modifiers

```swift
// Tinting
.glassEffect(.regular.tint(.purple.opacity(0.8)))

// Interactive (press scaling, bounce, shimmer, touch illumination)
.glassEffect(.regular.interactive())

// Combined
.glassEffect(.regular.tint(.blue).interactive())
```

### Shape Options

```swift
.glassEffect(in: .capsule)                              // Rounded pill (default)
.glassEffect(in: .circle)                                // Circle
.glassEffect(in: .ellipse)                               // Ellipse
.glassEffect(in: RoundedRectangle(cornerRadius: 16))     // Custom corners
.glassEffect(in: .rect(cornerRadius: .containerConcentric)) // Match container
```

### Container (Grouping Glass Elements)

```swift
GlassEffectContainer(spacing: 8) {
    // Child views with .glassEffect()
    // Glass elements closer than `spacing` will morph together
}
```

Glass cannot sample other glass. Use `GlassEffectContainer` when elements are near each other.

### Morphing Transitions

```swift
@Namespace var namespace

// Assign IDs for morph animation
view.glassEffectID(someID, in: namespace)

// Union glass elements
view.glassEffectUnion(id: groupID, namespace: namespace)

// Transitions
view.glassEffectTransition(.slide, isEnabled: true)
```

Requires same container and `withAnimation()` context.

### Background Glass

```swift
.glassBackgroundEffect(in: .rect(cornerRadius: 16), displayMode: .always)
```

### Button Styles

```swift
Button("Action") { }
    .buttonStyle(.glass)              // Translucent glass button

Button("Primary") { }
    .buttonStyle(.glassProminent)     // Opaque prominent glass button

Button("Icon") { }
    .buttonStyle(.glass)
    .buttonBorderShape(.circle)       // Circular variant
```

### Text on Glass

Text on glass automatically gets **vibrant color treatment** — brightness, saturation, and color adjust based on background content. Use high-contrast foreground colors (`.white`) for legibility.

## Accessibility

Glass effects adapt automatically for accessibility settings:

```swift
@Environment(\.accessibilityReduceTransparency) var reduceTransparency
@Environment(\.accessibilityReduceMotion) var reduceMotion
```

- `reduceTransparency` enabled: frosting automatically increases
- `reduceMotion` enabled: animations are toned down
- Increased contrast: system adapts automatically
- iOS 26.1+ supports tinted mode

Always test with these settings toggled on.

## References

- [Liquid Glass Overview — Apple Developer](https://developer.apple.com/documentation/TechnologyOverviews/liquid-glass)
- [Applying Liquid Glass to Custom Views — Apple Developer](https://developer.apple.com/documentation/SwiftUI/Applying-Liquid-Glass-to-custom-views)
- [glassEffect(_:in:) — Apple Developer](https://developer.apple.com/documentation/swiftui/view/glasseffect(_:in:))
- [Meet Liquid Glass — WWDC25](https://developer.apple.com/videos/play/wwdc2025/219/)
- [Get to Know the New Design System — WWDC25](https://developer.apple.com/videos/play/wwdc2025/356/)
