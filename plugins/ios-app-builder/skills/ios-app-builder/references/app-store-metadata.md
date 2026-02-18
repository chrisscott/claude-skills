# App Store Connect Metadata Reference

## Metadata Character Limits

| Field | Limit | Notes |
|-------|-------|-------|
| **App Name** | 30 chars | Primary discoverability factor |
| **Subtitle** | 30 chars | Appears below app name throughout the store |
| **Keywords** | 100 chars | Comma-separated, no spaces between terms (spaces within phrases OK) |
| **Promotional Text** | 170 chars | Can update WITHOUT a new version; does NOT affect search ranking |
| **Description** | 4,000 chars | Requires a new version to change |
| **What's New** | 4,000 chars | Shown on product page and Updates tab |
| **In-App Purchase Display Name** | 30 chars | Per IAP item |
| **In-App Purchase Description** | 45 chars | Per IAP item |

## AppStoreConnect.md Template

Track this in the project root:

```markdown
# App Store Connect Metadata

## App Information
- **App Name**: [30 chars max]
- **Subtitle**: [30 chars max]
- **Primary Category**:
- **Secondary Category**:
- **Content Rights**:
- **Age Rating**:

## Keywords
[100 chars max, comma-separated]

## Description
[4,000 chars max]

## Promotional Text
[170 chars max — update anytime without a new version]

## What's New (Current Version)
[4,000 chars max]

## URLs
- **Privacy Policy**:
- **Support URL**:
- **Marketing URL**:

## Release Tracking

### Version 1.0 Features
- Feature 1
- Feature 2

### Version 1.1 Features (planned)
- Feature 3
```

## Screenshot Specifications

### File Requirements
- Formats: `.png` (preferred) or `.jpeg`/`.jpg`
- Color space: RGB only (no CMYK, indexed, or grayscale)
- No transparency (flatten images)
- 1-10 screenshots per device per localization

### Required Base Sizes (Apple auto-scales from these)

| Device | Portrait | Landscape |
|--------|----------|-----------|
| **iPhone 6.9"** (Pro Max, Plus, Air) | 1260 x 2736 | 2736 x 1260 |
| **iPad 13"** (Pro, Air) | 2064 x 2752 | 2752 x 2064 |

### All iPhone Sizes

| Display | Portrait | Landscape |
|---------|----------|-----------|
| 6.9" | 1260 x 2736 | 2736 x 1260 |
| 6.5" | 1284 x 2778 or 1242 x 2688 | 2778 x 1284 or 2688 x 1242 |
| 6.3" | 1179 x 2556 or 1206 x 2622 | 2556 x 1179 or 2622 x 1206 |
| 6.1" | 1170 x 2532 or 1125 x 2436 or 1080 x 2340 | (corresponding) |
| 5.5" | 1242 x 2208 | 2208 x 1242 |
| 4.7" | 750 x 1334 | 1334 x 750 |

### iPad Sizes

| Display | Portrait | Landscape |
|---------|----------|-----------|
| 13" | 2064 x 2752 or 2048 x 2732 | 2752 x 2064 or 2732 x 2048 |
| 11" | 1488 x 2266 or 1668 x 2420 | (corresponding) |
| 10.5" | 1668 x 2224 | 2224 x 1668 |

### Other Platforms

| Platform | Size |
|----------|------|
| Mac | 2880 x 1800 or 2560 x 1600 (16:10 ratio) |
| Apple TV | 3840 x 2160 or 1920 x 1080 |
| Apple Vision Pro | 3840 x 2160 |
| Apple Watch Ultra | 422 x 514 |
| Apple Watch Series 11/10 | 416 x 496 |

### App Preview Videos
- Duration: 15-30 seconds
- Format: H.264 or ProRes 422 HQ
- Max size: 500 MB
- Up to 3 per localization

### Screenshot Content Rules

**Prohibited:**
- Marketing claims ("#1 App", "Best App")
- Calls to action ("Download Now")
- External URLs or QR codes
- Real user data
- Copyrighted third-party content
- Concept mockups of unbuilt features

**Required:**
- Actual in-app UI only
- Features that exist in the current build
- Localized text matching the storefront language

## Submission Checklist

- [ ] App Name, Subtitle, Keywords filled and within limits
- [ ] Description complete (first sentence is critical — it's shown in search)
- [ ] Promotional Text drafted
- [ ] What's New written for this version
- [ ] Screenshots generated for iPhone 6.9" (minimum required)
- [ ] Screenshots generated for iPad 13" (if universal app)
- [ ] App icon 1024x1024, no alpha channel, in asset catalog
- [ ] Privacy Policy URL live and accessible
- [ ] Support URL live and accessible
- [ ] Privacy manifest (PrivacyInfo.xcprivacy) accurate
- [ ] Export compliance answered
- [ ] Content rights confirmed
- [ ] IDFA usage declared (if applicable)
- [ ] Age rating questionnaire completed
