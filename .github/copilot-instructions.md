# settings_ui_plus - AI Coding Agent Instructions

## Project Overview
Flutter package for building native-looking settings screens. **Pure Dart package**—no native plugin code. A single API automatically adapts to **Material** and **Cupertino** design guidelines. Supports navigation, switch, slider, radio, and dropdown tiles with built-in theming, accessibility, and search.

## Architecture Philosophy

### Platform Delegation Pattern
Public widgets read the platform from `SettingsTheme` InheritedWidget and delegate to internal platform-specific implementations:
```
SettingsSection  → MaterialSettingsSection  OR  IOSSettingsSection
SettingsTile     → MaterialSettingsTile     OR  IOSSettingsTile
```
Platform-specific files are **not exported** — they are internal implementation details.

### Three-Tier Theming
```
ThemeProvider defaults  →  list-level overrides (lightTheme/darkTheme)  →  per-tile overrides (SettingsTileThemeData)
```
Each level merges on top of the previous. `SettingsThemeData.fromColorScheme()` generates a complete theme from a Material 3 `ColorScheme`.

### Key Files & Responsibilities
| File | Purpose | Critical Details |
|------|---------|------------------|
| `lib/settings_ui_plus.dart` | **Barrel export**—add ALL new public APIs here | Re-exports from `src/` |
| `lib/src/list/settings_list.dart` | `SettingsList` root widget | Resolves platform, brightness, theme. Wraps in `SettingsTheme` InheritedWidget |
| `lib/src/list/searchable_settings_list.dart` | `SearchableSettingsList` | Wraps `SettingsList` with search filtering by `searchTerms` |
| `lib/src/list/sliver_settings_list.dart` | `SliverSettingsList` | Sliver variant for `CustomScrollView` |
| `lib/src/sections/settings_section.dart` | `SettingsSection` | Platform switch → `MaterialSettingsSection` / `IOSSettingsSection` |
| `lib/src/sections/platforms/material_settings_section.dart` | Material section rendering | Card layout (web), flat list (mobile), expandable via mixin |
| `lib/src/sections/platforms/ios_settings_section.dart` | iOS section rendering | Rounded corners, `IOSSettingsTileAdditionalInfo` InheritedWidget |
| `lib/src/tiles/settings_tile.dart` | `SettingsTile` (6 constructors) | Platform switch → `MaterialSettingsTile` / `IOSSettingsTile` |
| `lib/src/tiles/platforms/material_settings_tile.dart` | Material tile rendering | `InkWell`, `Switch`, `DropdownButton`, `Slider`, `Semantics` |
| `lib/src/tiles/platforms/ios_settings_tile.dart` | iOS tile rendering | `GestureDetector`, `CupertinoSwitch`, `CupertinoSlider`, `CupertinoActionSheet` |
| `lib/src/utils/settings_theme.dart` | `SettingsTheme` InheritedWidget | `SettingsThemeData` (14 fields), `SettingsTileThemeData` (6 fields) |
| `lib/src/utils/theme_provider.dart` | Default themes per platform | Tuple-keyed cache: `(DevicePlatform, Brightness) → SettingsThemeData` |
| `lib/src/utils/expandable_section_mixin.dart` | Shared expand/collapse animation | Mixin on `SingleTickerProviderStateMixin` |
| `lib/src/utils/platform_utils.dart` | `DevicePlatform` enum | Detects platform from `Theme.of(context).platform` + `kIsWeb` |

## Development Workflow

### Running & Testing
```bash
cd example && flutter run              # Run example app
flutter test                           # All unit tests (107 unit + 4 golden)
flutter test test/settings_ui_plus_test.dart  # Unit tests only
flutter test test/golden_test.dart     # Golden tests only
flutter analyze                        # Lint checks
dart format lib test                   # Format code
dart pub publish --dry-run             # Verify publishable
```

### Updating Golden Files
When visual changes are intentional:
```bash
flutter test --update-goldens test/golden_test.dart
```
Golden files are in `test/goldens/` — 4 variants: `material_light.png`, `material_dark.png`, `ios_light.png`, `ios_dark.png`.

### Example App
```
example/lib/main.dart  →  Comprehensive demo covering all tile types, theming, search, slivers
```

## Code Patterns

### SettingsTile Constructors
Six named constructors, each setting `tileType` via initializer list:
```dart
SettingsTile(...)              // simpleTile
SettingsTile.navigation(...)   // navigationTile (shows chevron on iOS)
SettingsTile.switchTile(...)   // switchTile (Material Switch / CupertinoSwitch)
SettingsTile.radioTile(...)    // radioTile (checkmark when selected)
SettingsTile.sliderTile(...)   // sliderTile (Material Slider / CupertinoSlider)
SettingsTile.dropdownTile(...) // dropdownTile (DropdownButton / CupertinoActionSheet)
```

### InheritedWidget Usage
- `SettingsTheme` — propagates `SettingsThemeData` + `DevicePlatform` down the tree
- `IOSSettingsTileAdditionalInfo` — carries border radius and divider info per-tile in iOS sections

### Expandable Sections
Both platform sections use `ExpandableSectionMixin`:
```dart
class MaterialSettingsSection extends StatefulWidget {
  // ...
}
class _MaterialSettingsSectionState extends State<MaterialSettingsSection>
    with SingleTickerProviderStateMixin, ExpandableSectionMixin {
  // initExpandable() in initState, disposeExpandable() in dispose
}
```
Respects `MediaQuery.disableAnimations` for accessibility.

### Accessibility
- All interactive tiles have `Semantics` wrappers (`button: true`, `hint: 'Double-tap to activate'`)
- Material disabled tiles: 38% opacity per Material 3
- iOS tiles: 44pt minimum touch target per Apple HIG
- RTL: `EdgeInsetsDirectional` in iOS tiles

### Search Filtering
`SearchableSettingsList` filters by matching the query against `SettingsTile.searchTerms` (auto-generated from title/description Text data if not explicitly provided).

## Critical Rules
1. **All public APIs must be exported** from `lib/settings_ui_plus.dart`
2. **Platform-specific files stay internal** — never export `MaterialSettingsTile`, `IOSSettingsTile`, etc.
3. **Use `const` constructors** on all public widgets
4. **New tile types** need implementations in BOTH `material_settings_tile.dart` AND `ios_settings_tile.dart`
5. **New section features** need implementations in BOTH `material_settings_section.dart` AND `ios_settings_section.dart`
6. **Theme changes** — update `SettingsThemeData` fields, `copyWith`, `merge`, `==`/`hashCode`, AND `ThemeProvider` defaults
7. **Zero external dependencies** — only depend on Flutter SDK
8. **Test coverage** — add unit tests for new features, update golden tests if visual changes occur
9. Windows maps to Material — `DevicePlatform.windows` uses `MaterialSettingsTile`/`MaterialSettingsSection`

## Adding New Tile Types
1. Add enum value to `SettingsTileType` in `settings_tile.dart`
2. Add named constructor to `SettingsTile` with relevant parameters
3. Add rendering in `MaterialSettingsTile._buildTileContent()` (switch on `tileType`)
4. Add rendering in `IOSSettingsTile._buildTileContent()` (switch on `tileType`)
5. Add `searchTerms` support in `SearchableSettingsList._matchesTile()`
6. Export any new public types from `lib/settings_ui_plus.dart`
7. Add tests in `test/settings_ui_plus_test.dart`
8. Update golden tests if visual output changes
9. Update example app in `example/lib/main.dart`

## Package Structure
- **Pure Dart package:** No native code — only Flutter SDK
- **Platforms:** All Flutter platforms (Android, iOS, macOS, Linux, Windows, Web)
- **SDK:** Dart `^3.11.0`, Flutter `>=3.19.0`
- **Dependencies:** `flutter` SDK only (zero external deps)
- **Dev dependencies:** `flutter_test` SDK, `flutter_lints: ^6.0.0`

## Documentation References
- [README.md](README.md) — Installation, features, usage examples, comparison table
- [CHANGELOG.md](CHANGELOG.md) — Version history with detailed release notes
- [example/lib/main.dart](example/lib/main.dart) — Comprehensive demo app
- [pub.dev](https://pub.dev/packages/settings_ui_plus) — Published package page
