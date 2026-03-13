# settings_ui_plus

[![Pub Version](https://img.shields.io/pub/v/settings_ui_plus)](https://pub.dev/packages/settings_ui_plus)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)

Build native-looking settings screens in Flutter with minimal effort. Automatically adapts to **Material** and **Cupertino** design guidelines.

> A maintained fork of the original [`settings_ui`](https://github.com/yako-dev/flutter-settings-ui) package — modernized, improved, and actively developed.

---

## Preview

| iPhone (Light) | iPhone (Dark) | Android (Light) | Android (Dark) |
|---|---|---|---|
| <img src="shots/iphone/light/01.png" width="200"> | <img src="shots/iphone/dark/01.png" width="200"> | <img src="shots/android/light/01.png" width="200"> | <img src="shots/android/dark/01.png" width="200"> |

| macOS (Light) | macOS (Dark) | Web (Light) | Web (Dark) |
|---|---|---|---|
| <img src="shots/macos/light.PNG" width="200"> | <img src="shots/macos/dark.PNG" width="200"> | <img src="shots/web/light.PNG" width="200"> | <img src="shots/web/dark.PNG" width="200"> |

---

## Features

- Platform-adaptive UI (Material + Cupertino)
- Navigation, switch, slider, and radio tiles
- Expandable & collapsible sections
- Section headers and footers
- Custom tiles and custom sections
- Disabled tile support
- Long-press callbacks on all tiles
- Light/dark theme overrides via `SettingsThemeData`
- Accessible (semantics, 44pt touch targets, reduced-motion support)
- RTL and desktop ready

---

## Installation

```yaml
dependencies:
  settings_ui_plus: ^0.2.1
```

```dart
import 'package:settings_ui_plus/settings_ui_plus.dart';
```

---

## Quick Example

```dart
SettingsList(
  sections: [
    SettingsSection(
      title: const Text('Preferences'),
      tiles: [
        SettingsTile.switchTile(
          title: const Text('Dark Mode'),
          leading: const Icon(Icons.dark_mode),
          initialValue: false,
          onToggle: (value) {},
        ),
        SettingsTile.navigation(
          title: const Text('Language'),
          leading: const Icon(Icons.language),
          value: const Text('English'),
          onPressed: (context) {},
        ),
        SettingsTile.sliderTile(
          title: const Text('Font Size'),
          leading: const Icon(Icons.text_fields),
          sliderValue: 16,
          sliderMin: 10,
          sliderMax: 30,
          value: const Text('16'),
          onSliderChanged: (value) {},
        ),
      ],
    ),
    SettingsSection(
      title: const Text('About'),
      expandable: true,
      initiallyExpanded: false,
      footer: const Text('Your data is stored securely.'),
      tiles: [
        SettingsTile.navigation(
          title: const Text('Privacy Policy'),
          leading: const Icon(Icons.privacy_tip_outlined),
        ),
      ],
    ),
  ],
)
```

---

## Example App

A full example app with multiple sections, sub-screens, theme switching, radio tiles, sliders, and more is included in the repository:

**[example/lib/main.dart](example/lib/main.dart)**

---

## License

Apache 2.0 — inherited from the original [`settings_ui`](https://github.com/yako-dev/flutter-settings-ui) package. See [LICENSE](LICENSE) for details.
