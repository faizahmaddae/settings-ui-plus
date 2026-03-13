## 0.2.7

- Fixed CI golden test failures by excluding platform-sensitive golden tests from CI runners.
- Added `@Tags(['golden'])` annotation and `dart_test.yaml` for proper test tag management.

## 0.2.6

- Added GitHub Actions CI workflow (format, analyze, test on every push/PR).
- Added automated pub.dev publishing via OIDC on version tags.
- Added `.github/copilot-instructions.md` for AI-assisted development.

## 0.2.5

- Updated README with documentation for all new v0.2.4 features: dropdown tiles, searchable settings, sliver support, per-tile theming, animated value transitions, and `fromColorScheme` factory.
- Added usage examples for every new widget.
- Updated comparison table and installation version.

## 0.2.4

### New Features
- **`SearchableSettingsList`** — drop-in replacement for `SettingsList` with a built-in search bar that filters sections and tiles in real time by title and description.
- **`SliverSettingsList`** — sliver-based variant of `SettingsList` for embedding settings inside a `CustomScrollView` alongside other slivers.
- **`SettingsTile.dropdownTile`** — new constructor for inline dropdown selection with platform-adaptive rendering (Material `DropdownButton` / Cupertino action sheet).
- **`SettingsTileThemeData`** — per-tile theme override via `SettingsTile.tileTheme`, allowing individual tiles to override the global `SettingsThemeData`.
- **Animated value transitions** — tile `value` widgets now cross-fade smoothly using `AnimatedSwitcher` instead of snapping instantly.
- **`SettingsThemeData.fromColorScheme`** factory — generates a complete `SettingsThemeData` from a Flutter `ColorScheme` for quick Material 3 integration.
- **Golden tests** — added visual regression tests for Material and iOS variants in both light and dark themes.

### Fixes
- **Brightness override respected** — `SettingsList.calculateBrightness()` now correctly returns the explicit `brightness` parameter when provided, instead of always falling through to `MediaQuery` / platform brightness.

### Improvements
- Added dartdoc comments to all public API members for full documentation coverage.
- Removed unnecessary library name to fix `unnecessary_library_name` lint.

## 0.2.2

- Fixed LICENSE file formatting so pub.dev correctly recognizes Apache-2.0.

## 0.2.1

### Accessibility & Platform Fidelity
- **Semantics enrichment** — all interactive tiles now expose `button: true` and `hint: 'Double-tap to activate'` for screen readers.
- **Material disabled opacity** — disabled tiles render at 38% opacity per Material 3 guidelines (previously no visual change).
- **iOS minimum touch target** — all iOS tiles enforce a 44pt minimum height per Apple HIG.
- **iOS press feedback** — replaced background-color swap with `Opacity(0.7)` for a smoother, more native press effect.
- **Keyboard focus color** — Material `InkWell` now shows a primary-tinted focus ring for keyboard navigation.
- **Expand animation accessibility** — expandable sections respect `MediaQuery.disableAnimations`, collapsing instantly when system animations are off.
- **RTL support** — iOS tile descriptions use `EdgeInsetsDirectional` for correct right-to-left layout.

### Visual Fixes
- **Font sizes aligned** — Material tiles use 16px (M3 bodyLarge), iOS tiles use 17px (San Francisco default).
- **Padding grid alignment** — Material uses 16dp grid, iOS uses 12pt (8pt grid) for consistent spacing.
- **iOS chevron size** — reduced from 18pt to 14pt to match Apple HIG.
- **Hover alpha** — increased from 30 to 50 for better visibility on desktop.
- **Dark mode contrast** — iOS dark-mode title color changed to `rgba(152, 152, 159)` for WCAG-compliant contrast.
- **Divider thickness** — standardized to 1.0 across all platforms.
- **Web section title padding** — made symmetric (`start: 6, end: 6`).

### Fixes
- **Switch default consistency** — `CupertinoSwitch` now defaults to `false` (was `true`) when no `initialValue` is provided.
- **CupertinoSwitch native disabled** — uses `activeTrackColor` instead of deprecated `activeColor`; lets the native widget handle its own disabled appearance.
- **Slider label** — Material slider now shows a value popup label when `sliderDivisions` is set.
- **Long-press state reset** — press state is now cleared before invoking `onLongPress` callbacks to avoid stuck highlight.
- **Empty section guard** — Material sections with no tiles, title, or footer return `SizedBox.shrink()` instead of rendering an empty card.

## 0.2.0

### New features
- **`SettingsTile.sliderTile`** — new constructor for inline slider controls with `sliderValue`, `sliderMin`, `sliderMax`, `sliderDivisions`, `onSliderChanged`, and `sliderActiveColor`. Renders a Material `Slider` or Cupertino `CupertinoSlider` based on platform.
- **`SettingsTile.radioTile`** — new constructor for single-select option groups with platform-native checkmark rendering.
- **Expandable sections** — `SettingsSection` gains `expandable` and `initiallyExpanded` parameters with smooth animated collapse/expand and a rotating disclosure icon.
- **Section footers** — `SettingsSection` gains an optional `footer` widget for help text or disclaimers below tiles.
- **`onLongPress`** callback on all tile constructors (`SettingsTile`, `.navigation`, `.switchTile`, `.radioTile`, `.sliderTile`).
- **Text-style theming** — `SettingsThemeData` now includes `titleTextStyle`, `descriptionTextStyle`, and `sectionTitleTextStyle` for full typographic control.
- **Desktop hover & cursor** — Material tiles show a hover highlight and appropriate mouse cursor on desktop platforms.
- **Accessibility** — `Semantics` wrappers on all interactive tiles (Material and iOS) for screen-reader support.

### Fixes
- Fixed iOS tile press state using redundant `Future.delayed` — now handled cleanly by gesture callbacks.
- Fixed Material divider not respecting `SettingsThemeData.dividerColor`.
- Fixed `IOSSettingsTileAdditionalInfo.of()` silently returning a fallback widget — now throws a clear assertion when used outside an `IOSSettingsSection`.
- Fixed crash when `SettingsSection.tiles` list is empty on iOS.
- Fixed `MediaQuery.of(context).size` → `MediaQuery.sizeOf(context)` in three locations (avoids unnecessary rebuilds).
- Fixed Windows platform routing — sections, tiles, **and** theme now consistently use Material layout and colors.
- Fixed missing `settingsSectionBackground` and `dividerColor` in Android dark theme.
- Fixed missing `tileDescriptionTextColor` in iOS dark theme.

### Improvements
- **Extracted `ExpandableSectionMixin`** — shared expand/collapse animation logic is now DRY across Material and iOS sections.
- **Text overflow handling** — tile titles (max 2 lines) and descriptions (max 3 lines) now show ellipsis instead of overflowing.
- **iOS disabled state** — disabled tiles on iOS now render at 50% opacity for clearer visual feedback.
- **Radio tile selected background** — selected radio tiles on Material show a subtle primary-color tint.
- **ThemeProvider caching** — platform themes are now cached to avoid unnecessary allocations on every rebuild.
- **Better error message** — `SettingsTheme.of()` now throws an assertion with a clear message if used outside a `SettingsList`.
- Removed dead `WebSettingsSection` and `WebSettingsTile` files (web already routes to Material implementations).
- Exported `ApplicationType` enum from the barrel file.
- Added dartdoc comments to all public API classes.
- Cleaned up indentation issues in `MaterialSettingsTile` and `SettingsList`.
- Updated README with full feature documentation.

## 0.1.0

- **Breaking**: Removed `DevicePlatform.device` sentinel value. Use `null` (auto-detect) or a specific platform instead.
- **Breaking**: `ThemeProvider.getTheme()` no longer requires a `BuildContext` parameter.
- Merged duplicate Android/Web platform tiles into `MaterialSettingsTile`.
- Merged duplicate Android/Web platform sections into `MaterialSettingsSection`.
- Fixed web tiles not dimming title/icon/subtitle when `enabled: false`.
- Fixed web theme missing `inactiveTitleColor` and `inactiveSubtitleColor`.
- Fixed `SettingsTheme.updateShouldNotify` to compare data instead of always returning `true`.
- Fixed `IOSSettingsTileAdditionalInfo.updateShouldNotify` to compare fields.
- Replaced deprecated `textScaleFactor` with `MediaQuery.textScalerOf`.
- Replaced deprecated `Switch.activeColor` / `CupertinoSwitch.activeColor` with `activeTrackColor`.
- Modernized constructors with `super.key` and `super.child`.
- Reorganized `ThemeProvider` color constants into dedicated palette classes.
- Hidden `PlatformUtils` from public API (only `DevicePlatform` is exported).
- Added `==` / `hashCode` to `SettingsThemeData`.
- Added widget tests.
- Added example app.
- Updated README with API reference and usage examples.
