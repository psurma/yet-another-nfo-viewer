# Changelog

## [2.0.0] - 2026-03-06

### Added
- **NFORenderKit** Swift Package (macOS 13+) with shared rendering logic:
  - `NFODocument.swift` — CP437 (DOS code page 437) file decoding
  - `NFORenderer.swift` — font registration + `NSAttributedString` generation with "More Perfect DOS VGA" font, black on white
  - Full unit test suite (7 tests) covering encoding, rendering, colors, and font size
- **QuickLookNFO** Xcode project (generated via XcodeGen from `project.yml`):
  - `QuickLookNFOApp` — minimal macOS stub app that exports UTIs for `.nfo`, `.asc`, `.diz`
  - `NFOPreviewExtension` — Quick Look Preview Extension that renders NFO/ASC/DIZ files in Finder (press Space)
  - Fonts bundled in the extension and registered at preview time via `CTFontManagerRegisterFontsForURL`
  - `project.yml` XcodeGen spec keeps the `.xcodeproj` generated and diff-friendly
  - App Sandbox entitlements on both targets (required for pluginkit registration)

### Setup notes
After building in Xcode, enable the extension once:
```bash
pluginkit -e use -i com.yanvi.QuickLookNFO.NFOPreviewExtension
qlmanage -r
```
