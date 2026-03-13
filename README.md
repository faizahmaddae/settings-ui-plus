# settings_ui_plus

[![Pub Version](https://img.shields.io/pub/v/settings_ui_plus)](https://pub.dev/packages/settings_ui_plus)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)

A Flutter package for building beautiful, native-looking settings screens with minimal effort. A single, unified API that automatically adapts to **Material** (Android, Web, Windows, Linux, Fuchsia) and **Cupertino** (iOS, macOS) design guidelines.

> **Fork notice** — This package is a fork and continuation of the original [`settings_ui`](https://github.com/yako-dev/flutter-settings-ui) package by [yako-dev](https://github.com/yako-dev). The original project is no longer actively maintained. `settings_ui_plus` picks up where it left off — modernized, improved, and maintained for current and future versions of Flutter.

---

## Overview

Building a settings screen that feels native on every platform is tedious. You need one layout for Material, another for Cupertino, and careful attention to accessibility, theming, and platform conventions. **settings_ui_plus** eliminates that work.

Pass your sections and tiles through a single API and the package handles the rest — Cupertino grouped lists with inset styling on iOS, Material cards with ripple feedback on Android, proper disabled states, RTL support, hover/focus states for desktop, and more.

**Why use this package?**

- Write your settings screen **once**, get native behaviour on every platform.
- Drop-in tile types for the most common patterns: navigation, switches, radio groups, and sliders.
- Full theming control without fighting platform defaults.
- Actively maintained — bug fixes, new features, and Flutter version compatibility.

---

## Origin

`settings_ui_plus` is based on the original [`settings_ui`](https://github.com/yako-dev/flutter-settings-ui) package, which earned over 900 stars on GitHub and was widely adopted by the Flutter community. When the original project became inactive, this fork was created to:

- **Keep the package up to date** with the latest Flutter and Dart SDK releases.
- **Fix known bugs** — including cross-platform rendering issues, duplicate widget rendering, and incorrect disabled states.
- **Add missing features** — slider tiles, radio tiles, expandable sections, section footers, long-press callbacks, custom sections, and comprehensive theming.
- **Improve accessibility** — semantic labels, minimum touch targets, animation-preference awareness.
- **Modernize the codebase** — null safety, Flutter 3.x best practices, Material 3 support.

The goal is to provide the Flutter community with a **better maintained, more flexible, and more complete** settings UI solution that respects the work of the original authors while moving the package forward.

---

## Features

- **Platform-adaptive rendering** — Material on Android/Web/Desktop, Cupertino on iOS/macOS, selected automatically or overridden manually.
- **Rich tile types** — simple, navigation (with chevron), switch, radio, and slider tiles out of the box.
- **Expandable sections** — collapse and expand groups of tiles with a smooth animation.
- **Section footers** — display help text, disclaimers, or legal notices below any section.
- **Custom tiles and sections** — drop any widget into `CustomSettingsTile` or `CustomSettingsSection` for maximum flexibility.
- **Theming** — override colours and text styles via `SettingsThemeData` with separate `lightTheme` and `darkTheme` support.
- **Disabled tiles** — grey out tiles and block interaction with a single `enabled: false` flag.
- **Long-press support** — every tile type accepts an `onLongPress` callback.
- **Accessible** — `Semantics` with button role and activation hints; enforces minimum 44pt touch targets on iOS; supports `disableAnimations`.
- **RTL-ready** — directional padding for correct right-to-left layouts.
- **Desktop-ready** — hover highlights, focus rings, and pointer cursors on mouse-driven platforms.

---

## Screenshots

<!-- Replace these placeholders with actual screenshots of your app -->

| Light Mode | Dark Mode |
|---|---|
| ![Settings Screen — Light](screenshots/settings_light.png) | ![Settings Screen — Dark](screenshots/settings_dark.png) |

| iOS | Android |
|---|---|
| ![iOS Settings](screenshots/settings_ios.png) | ![Android Settings](screenshots/settings_android.png) |

---

## Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  settings_ui_plus: ^0.2.1
```

Then run:

```bash
flutter pub get
```

Import it in your Dart code:

```dart
import 'package:settings_ui_plus/settings_ui_plus.dart';
```

---

## Basic Usage

Build a settings screen in seconds with `SettingsList`, `SettingsSection`, and `SettingsTile`:

```dart
SettingsList(
  sections: [
    SettingsSection(
      title: const Text('General'),
      tiles: [
        SettingsTile(
          title: const Text('Language'),
          value: const Text('English'),
          leading: const Icon(Icons.language),
          onPressed: (context) {
            // Handle tap
          },
        ),
        SettingsTile.navigation(
          title: const Text('Account'),
          leading: const Icon(Icons.person),
          onPressed: (context) {
            // Navigate to account screen
          },
        ),
      ],
    ),
  ],
)
```

---

## Tile Types

### Navigation Tile

Displays a trailing chevron (iOS) or navigational affordance and is the most common tile variant for drill-down settings.

```dart
SettingsTile.navigation(
  title: const Text('Account'),
  leading: const Icon(Icons.person),
  value: const Text('Alex Johnson'),
  onPressed: (context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AccountScreen()),
    );
  },
)
```

### Switch Tile

A toggle control for boolean settings. Renders a `Switch` on Material and a `CupertinoSwitch` on iOS.

```dart
SettingsTile.switchTile(
  title: const Text('Notifications'),
  leading: const Icon(Icons.notifications_outlined),
  description: const Text('Receive push notifications'),
  initialValue: notificationsEnabled,
  activeSwitchColor: Colors.green,
  onToggle: (value) {
    setState(() => notificationsEnabled = value);
  },
)
```

### Slider Tile

Embed an inline slider directly in a settings row. Renders a `Slider` on Material and a `CupertinoSlider` on iOS.

```dart
SettingsTile.sliderTile(
  title: const Text('Font Size'),
  leading: const Icon(Icons.text_fields),
  sliderValue: fontSize,
  sliderMin: 10,
  sliderMax: 30,
  sliderDivisions: 20,
  value: Text('${fontSize.round()}'),
  description: const Text('Adjust the base font size'),
  onSliderChanged: (value) {
    setState(() => fontSize = value);
  },
)
```

### Radio Tile

Create single-select option groups. A checkmark appears next to the selected option.

```dart
SettingsSection(
  title: const Text('Language'),
  tiles: [
    SettingsTile.radioTile(
      title: const Text('English'),
      selected: selectedLanguage == 'en',
      onPressed: (_) => setState(() => selectedLanguage = 'en'),
    ),
    SettingsTile.radioTile(
      title: const Text('Spanish'),
      selected: selectedLanguage == 'es',
      onPressed: (_) => setState(() => selectedLanguage = 'es'),
    ),
    SettingsTile.radioTile(
      title: const Text('French'),
      selected: selectedLanguage == 'fr',
      onPressed: (_) => setState(() => selectedLanguage = 'fr'),
    ),
  ],
)
```

### Custom Tile

Drop any widget into a section using `CustomSettingsTile`:

```dart
const CustomSettingsTile(
  child: Padding(
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    child: Text(
      'App version 1.0.0',
      style: TextStyle(color: Colors.grey, fontSize: 13),
      textAlign: TextAlign.center,
    ),
  ),
)
```

---

## Sections

Group related tiles under a `SettingsSection` with an optional `title` and `footer`:

```dart
SettingsSection(
  title: const Text('Privacy'),
  footer: const Text(
    'Your data is encrypted end-to-end and never shared without your consent.',
  ),
  tiles: [
    SettingsTile.switchTile(
      title: const Text('Face ID'),
      leading: const Icon(Icons.fingerprint),
      initialValue: faceIdEnabled,
      onToggle: (value) => setState(() => faceIdEnabled = value),
    ),
    SettingsTile.switchTile(
      title: const Text('Analytics'),
      leading: const Icon(Icons.analytics_outlined),
      initialValue: analyticsEnabled,
      onToggle: (value) => setState(() => analyticsEnabled = value),
    ),
  ],
)
```

### Expandable Sections

Sections can collapse and expand with a smooth animation:

```dart
SettingsSection(
  title: const Text('Advanced'),
  expandable: true,
  initiallyExpanded: false,
  tiles: [
    SettingsTile.navigation(
      title: const Text('Terms of Service'),
      leading: const Icon(Icons.description_outlined),
    ),
    SettingsTile.navigation(
      title: const Text('Open Source Licenses'),
      leading: const Icon(Icons.collections_bookmark_outlined),
    ),
  ],
)
```

### Custom Sections

Place any widget directly inside the settings list with `CustomSettingsSection`:

```dart
CustomSettingsSection(
  child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Column(
      children: [
        const CircleAvatar(radius: 40, child: Text('AJ')),
        const SizedBox(height: 12),
        Text('Alex Johnson', style: Theme.of(context).textTheme.titleLarge),
      ],
    ),
  ),
)
```

---

## Slider Example

A complete example showing a stateful slider tile that updates its label in real time:

```dart
class AppearanceSettings extends StatefulWidget {
  const AppearanceSettings({super.key});

  @override
  State<AppearanceSettings> createState() => _AppearanceSettingsState();
}

class _AppearanceSettingsState extends State<AppearanceSettings> {
  double _fontSize = 16;
  double _brightness = 75;

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          title: const Text('Display'),
          tiles: [
            SettingsTile.sliderTile(
              title: const Text('Font Size'),
              leading: const Icon(Icons.text_fields),
              sliderValue: _fontSize,
              sliderMin: 10,
              sliderMax: 30,
              sliderDivisions: 20,
              value: Text('${_fontSize.round()}'),
              onSliderChanged: (v) => setState(() => _fontSize = v),
            ),
            SettingsTile.sliderTile(
              title: const Text('Brightness'),
              sliderValue: _brightness,
              sliderMin: 0,
              sliderMax: 100,
              value: Text('${_brightness.round()}%'),
              sliderActiveColor: Colors.amber,
              onSliderChanged: (v) => setState(() => _brightness = v),
            ),
          ],
        ),
      ],
    );
  }
}
```

---

## Switch Example

A complete example showing switch tiles with state management:

```dart
class PreferenceSettings extends StatefulWidget {
  const PreferenceSettings({super.key});

  @override
  State<PreferenceSettings> createState() => _PreferenceSettingsState();
}

class _PreferenceSettingsState extends State<PreferenceSettings> {
  bool _darkMode = false;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          title: const Text('Preferences'),
          tiles: [
            SettingsTile.switchTile(
              title: const Text('Dark Mode'),
              leading: const Icon(Icons.dark_mode_outlined),
              initialValue: _darkMode,
              onToggle: (value) => setState(() => _darkMode = value),
            ),
            SettingsTile.switchTile(
              title: const Text('Notifications'),
              leading: const Icon(Icons.notifications_outlined),
              description: const Text('Receive push notifications'),
              initialValue: _notifications,
              activeSwitchColor: Colors.green,
              onToggle: (value) => setState(() => _notifications = value),
            ),
          ],
        ),
      ],
    );
  }
}
```

---

## Disabled Settings

Disable any tile by setting `enabled: false`. The tile renders at reduced opacity and ignores all interaction:

```dart
SettingsTile.switchTile(
  title: const Text('Location Services'),
  leading: const Icon(Icons.location_on_outlined),
  description: const Text('Permission not granted'),
  initialValue: false,
  onToggle: (_) {},
  enabled: false,
)
```

---

## Long-Press Callbacks

Every tile variant supports `onLongPress` for secondary actions like tips, quick pickers, or context menus:

```dart
SettingsTile.navigation(
  title: const Text('Change Password'),
  leading: const Icon(Icons.lock_outline),
  onPressed: (context) {
    // Navigate to change password screen
  },
  onLongPress: (context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tip: Use a strong, unique password')),
    );
  },
)
```

---

## Theming and Customization

### Light and Dark Themes

Override default platform colours and text styles per brightness mode:

```dart
SettingsList(
  lightTheme: const SettingsThemeData(
    settingsListBackground: Color(0xFFF2F2F7),
    titleTextColor: Colors.indigo,
    titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    descriptionTextStyle: TextStyle(fontSize: 14, color: Colors.grey),
    sectionTitleTextStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
  ),
  darkTheme: const SettingsThemeData(
    settingsListBackground: Color(0xFF1C1C1E),
  ),
  sections: [...],
)
```

### Available Theme Properties

| Property | Description |
|---|---|
| `settingsListBackground` | Background colour of the entire settings list. |
| `settingsSectionBackground` | Background colour of individual sections. |
| `titleTextColor` | Section title colour (defaults to `ColorScheme.primary` on Material). |
| `settingsTileTextColor` | Tile title text colour. |
| `tileDescriptionTextColor` | Tile description text colour. |
| `trailingTextColor` | Colour for trailing value text. |
| `leadingIconsColor` | Leading icon colour. |
| `dividerColor` | Colour of dividers between tiles. |
| `tileHighlightColor` | Hover / press highlight colour. |
| `inactiveTitleColor` | Title colour when `enabled: false`. |
| `inactiveSubtitleColor` | Subtitle colour when `enabled: false`. |
| `titleTextStyle` | Custom `TextStyle` for tile titles. |
| `descriptionTextStyle` | Custom `TextStyle` for tile descriptions. |
| `sectionTitleTextStyle` | Custom `TextStyle` for section headers. |

### Force a Specific Platform

Render the iOS Cupertino look on Android (or vice versa) for testing or design consistency:

```dart
SettingsList(
  platform: DevicePlatform.iOS,
  sections: [...],
)
```

---

## Complete Example

A full settings screen demonstrating multiple sections, tile types, custom sections, theming, and navigation:

```dart
import 'package:flutter/material.dart';
import 'package:settings_ui_plus/settings_ui_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;
  bool _faceId = true;
  double _fontSize = 16;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SettingsList(
        lightTheme: const SettingsThemeData(
          settingsListBackground: Color(0xFFF2F2F7),
        ),
        sections: [
          // Custom section: user profile card
          CustomSettingsSection(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  const CircleAvatar(radius: 40, child: Text('AJ')),
                  const SizedBox(height: 12),
                  Text('Alex Johnson',
                      style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ),
          ),

          // Preferences with switches
          SettingsSection(
            title: const Text('Preferences'),
            tiles: [
              SettingsTile.switchTile(
                title: const Text('Dark Mode'),
                leading: const Icon(Icons.dark_mode_outlined),
                initialValue: _darkMode,
                onToggle: (v) => setState(() => _darkMode = v),
              ),
              SettingsTile.switchTile(
                title: const Text('Notifications'),
                leading: const Icon(Icons.notifications_outlined),
                description: const Text('Receive push notifications'),
                initialValue: _notifications,
                activeSwitchColor: Colors.green,
                onToggle: (v) => setState(() => _notifications = v),
              ),
              SettingsTile.switchTile(
                title: const Text('Location Services'),
                leading: const Icon(Icons.location_on_outlined),
                description: const Text('Permission not granted'),
                initialValue: false,
                onToggle: (_) {},
                enabled: false,
              ),
              SettingsTile.navigation(
                title: const Text('Language'),
                leading: const Icon(Icons.language),
                value: Text(_language),
                onPressed: (context) {
                  // Navigate to language selection
                },
              ),
            ],
          ),

          // Appearance with sliders
          SettingsSection(
            title: const Text('Appearance'),
            tiles: [
              SettingsTile.sliderTile(
                title: const Text('Font Size'),
                leading: const Icon(Icons.text_fields),
                sliderValue: _fontSize,
                sliderMin: 10,
                sliderMax: 30,
                sliderDivisions: 20,
                value: Text('${_fontSize.round()}'),
                onSliderChanged: (v) => setState(() => _fontSize = v),
              ),
            ],
          ),

          // Privacy with footer
          SettingsSection(
            title: const Text('Privacy'),
            footer: const Text(
              'Your data is encrypted end-to-end and never shared '
              'without your explicit consent.',
            ),
            tiles: [
              SettingsTile.switchTile(
                title: const Text('Face ID'),
                leading: const Icon(Icons.fingerprint),
                initialValue: _faceId,
                onToggle: (v) => setState(() => _faceId = v),
              ),
            ],
          ),

          // Expandable About section
          SettingsSection(
            title: const Text('About'),
            expandable: true,
            initiallyExpanded: false,
            tiles: [
              SettingsTile.navigation(
                title: const Text('Terms of Service'),
                leading: const Icon(Icons.description_outlined),
              ),
              SettingsTile.navigation(
                title: const Text('Privacy Policy'),
                leading: const Icon(Icons.privacy_tip_outlined),
              ),
              SettingsTile.navigation(
                title: const Text('Open Source Licenses'),
                leading: const Icon(Icons.collections_bookmark_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

For a more comprehensive example with sub-screens, radio tiles, and theme switching, see the [example app](example/lib/main.dart).

---

## Accessibility

All interactive tiles are wrapped in `Semantics` with `button: true` and an activation hint for screen readers.

- **Material** — disabled tiles render at 38 % opacity; hover and focus states are clearly visible.
- **iOS** — tiles enforce a 44 pt minimum height per Apple HIG; press feedback uses opacity for a native feel.
- **Animations** — expandable sections respect `MediaQuery.disableAnimations` and collapse instantly when the user prefers reduced motion.

---

## API Reference

| Widget | Description |
|---|---|
| `SettingsList` | Top-level scrollable list of sections. Accepts `platform`, `lightTheme`, `darkTheme`, `brightness`, `contentPadding`, and `applicationType`. |
| `SettingsSection` | A group of tiles with an optional `title` and `footer`. Supports `expandable` and `initiallyExpanded`. |
| `SettingsTile` | A single setting row. Use `.navigation` for chevron tiles, `.switchTile` for toggles, `.radioTile` for single-select options, or `.sliderTile` for inline sliders. All variants support `onPressed`, `onLongPress`, `leading`, `trailing`, `description`, `value`, and `enabled`. |
| `CustomSettingsTile` | Wraps any widget to place inside a `SettingsSection`. |
| `CustomSettingsSection` | Wraps any widget to place inside a `SettingsList`. |
| `SettingsThemeData` | Colour and text-style overrides: `titleTextStyle`, `descriptionTextStyle`, `sectionTitleTextStyle`, plus 11 colour properties. |
| `ApplicationType` | Enum: `material`, `cupertino`, `both` — controls how brightness is resolved. |
| `DevicePlatform` | Enum: `android`, `iOS`, `web`, `macOS`, `windows`, `linux`, `fuchsia` — force a specific platform look. |

---

## Why settings_ui_plus?

| | `settings_ui` (original) | `settings_ui_plus` |
|---|---|---|
| **Maintained** | Inactive since 2023 | Actively maintained |
| **Flutter 3.x / Material 3** | Partial | Full support |
| **Slider tiles** | Not available | Built-in |
| **Radio tiles** | Not available | Built-in |
| **Expandable sections** | Not available | Built-in |
| **Section footers** | Not available | Built-in |
| **Long-press callbacks** | Not available | All tile types |
| **Custom sections** | Not available | `CustomSettingsSection` |
| **Accessibility** | Basic | Semantics, min touch targets, reduced-motion support |
| **Theming** | Limited | 14 colour/style properties, light + dark overrides |
| **Desktop support** | Minimal | Hover, focus, pointer cursor |

---

## Contributing

Contributions are welcome! Here's how you can help:

1. **Fork** the repository at [github.com/faizahmaddae/settings-ui-plus](https://github.com/faizahmaddae/settings-ui-plus).
2. **Create a branch** for your feature or bug fix.
3. **Write tests** — the project has 80+ tests; please cover any new behaviour.
4. **Run analysis** — `dart analyze` and `flutter test` should both pass cleanly.
5. **Open a pull request** with a clear description of your changes.

Bug reports, feature requests, and documentation improvements are all appreciated. Please open an issue on GitHub.

---

## License

This project is licensed under the **Apache 2.0 License**, inherited from the original [`settings_ui`](https://github.com/yako-dev/flutter-settings-ui) package. See [LICENSE](LICENSE) for full details.
