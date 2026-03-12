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
