# settings_ui_plus

A Flutter package for building native-looking settings screens with minimal effort. Automatically adapts to **Material** (Android, Web, Linux, Fuchsia) and **Cupertino** (iOS, macOS, Windows) design guidelines using a single, unified API.

## Features

- **Platform-adaptive** — renders Material or Cupertino styles automatically based on the running platform.
- **Theming** — full control over colors via `SettingsThemeData` with light/dark mode support.
- **Tile types** — simple tiles, navigation tiles with chevrons, and switch tiles out of the box.
- **Custom tiles & sections** — drop any widget into a `CustomSettingsTile` or `CustomSettingsSection`.
- **Override platform** — force a specific platform look with the `platform` parameter.

## Getting Started

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  settings_ui_plus: ^0.1.0
```

Then import it:

```dart
import 'package:settings_ui_plus/settings_ui_plus.dart';
```

## Usage

```dart
SettingsList(
  sections: [
    SettingsSection(
      title: const Text('Common'),
      tiles: [
        SettingsTile(
          title: const Text('Language'),
          value: const Text('English'),
          leading: const Icon(Icons.language),
          onPressed: (context) {},
        ),
      ],
    ),
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
          title: const Text('Account'),
          leading: const Icon(Icons.person),
        ),
      ],
    ),
  ],
)
```

### Custom theming

Override default colors per brightness:

```dart
SettingsList(
  lightTheme: const SettingsThemeData(
    settingsListBackground: Color(0xFFF5F5F5),
    titleTextColor: Colors.indigo,
  ),
  darkTheme: const SettingsThemeData(
    settingsListBackground: Color(0xFF121212),
  ),
  sections: [...],
)
```

### Force a specific platform

```dart
SettingsList(
  platform: DevicePlatform.iOS,
  sections: [...],
)
```

### Custom tiles and sections

```dart
SettingsSection(
  title: const Text('About'),
  tiles: [
    const CustomSettingsTile(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text('App version 1.0.0'),
      ),
    ),
  ],
)
```

## API Reference

| Widget | Description |
|---|---|
| `SettingsList` | Top-level scrollable list of sections. Accepts `platform`, `lightTheme`, `darkTheme`, `brightness`, `applicationType`. |
| `SettingsSection` | A group of tiles with an optional `title`. |
| `SettingsTile` | A single setting row. Use `.navigation` for chevron tiles or `.switchTile` for toggles. |
| `CustomSettingsTile` | Wraps any widget to place inside a `SettingsSection`. |
| `CustomSettingsSection` | Wraps any widget to place inside a `SettingsList`. |
| `SettingsThemeData` | Color overrides for backgrounds, text, icons, dividers, and inactive states. |
| `DevicePlatform` | Enum: `android`, `iOS`, `web`, `macOS`, `windows`, `linux`, `fuchsia`. |

## License

MIT — see [LICENSE](LICENSE) for details.
