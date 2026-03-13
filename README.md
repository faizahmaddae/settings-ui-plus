# settings_ui_plus

A Flutter package for building native-looking settings screens with minimal effort. Automatically adapts to **Material** (Android, Web, Windows, Linux, Fuchsia) and **Cupertino** (iOS, macOS) design guidelines using a single, unified API.

## Features

- **Platform-adaptive** — renders Material or Cupertino styles automatically based on the running platform.
- **Theming** — full control over colors and text styles via `SettingsThemeData` with light/dark mode support.
- **Tile types** — simple tiles, navigation tiles with chevrons, switch tiles, radio tiles, and slider tiles out of the box.
- **Expandable sections** — sections can be collapsed/expanded with a smooth animation.
- **Accessible** — `Semantics` with button role and activation hints on all tiles; respects system animation settings; enforces minimum touch targets.
- **RTL-ready** — directional padding for correct right-to-left layouts.
- **Desktop-ready** — hover highlights, focus rings, and pointer cursors for mouse-driven platforms.
- **Custom tiles & sections** — drop any widget into a `CustomSettingsTile` or `CustomSettingsSection`.
- **Override platform** — force a specific platform look with the `platform` parameter.

## Getting Started

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  settings_ui_plus: ^0.2.0
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

Override default colors and text styles per brightness:

```dart
SettingsList(
  lightTheme: const SettingsThemeData(
    settingsListBackground: Color(0xFFF5F5F5),
    titleTextColor: Colors.indigo,
    titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    descriptionTextStyle: TextStyle(fontSize: 14, color: Colors.grey),
    sectionTitleTextStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
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

### Radio tiles

Create single-select option groups with `SettingsTile.radioTile`:

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
  ],
)
```

### Expandable sections

Sections can collapse/expand with a smooth animation:

```dart
SettingsSection(
  title: const Text('Advanced'),
  expandable: true,
  initiallyExpanded: false,
  tiles: [...],
)
```

### Section footers

Add help text or disclaimers below a section:

```dart
SettingsSection(
  title: const Text('Account'),
  footer: const Text('Your data is stored securely.'),
  tiles: [...],
)
```

### Long-press callbacks

All tile types support `onLongPress`:

```dart
SettingsTile(
  title: const Text('Language'),
  onPressed: (context) => navigateTo(context),
  onLongPress: (context) => showQuickPicker(context),
)
```

### Slider tiles

Embed a slider directly in a settings row:

```dart
SettingsTile.sliderTile(
  title: const Text('Font Size'),
  leading: const Icon(Icons.text_fields),
  sliderValue: fontSize,
  sliderMin: 10,
  sliderMax: 30,
  sliderDivisions: 20,
  value: Text('${fontSize.round()}'),
  onSliderChanged: (value) => setState(() => fontSize = value),
)
```

## Accessibility

All interactive tiles are wrapped in `Semantics` with `button: true` and an activation hint for screen readers. Platform-specific behavior:

- **Material** — disabled tiles render at 38% opacity; hover and focus states are clearly visible.
- **iOS** — tiles enforce a 44pt minimum height per Apple HIG; press feedback uses opacity for a native feel.
- **Animations** — expandable sections respect `MediaQuery.disableAnimations` and collapse instantly when the system preference is set.

## API Reference

| Widget | Description |
|---|---|
| `SettingsList` | Top-level scrollable list of sections. Accepts `platform`, `lightTheme`, `darkTheme`, `brightness`, `applicationType`. |
| `SettingsSection` | A group of tiles with an optional `title` and `footer`. Supports `expandable` and `initiallyExpanded`. |
| `SettingsTile` | A single setting row. Use `.navigation` for chevron tiles, `.switchTile` for toggles, `.radioTile` for single-select options, or `.sliderTile` for inline sliders. All variants support `onPressed` and `onLongPress`. |
| `CustomSettingsTile` | Wraps any widget to place inside a `SettingsSection`. |
| `CustomSettingsSection` | Wraps any widget to place inside a `SettingsList`. |
| `SettingsThemeData` | Color and text-style overrides: `titleTextStyle`, `descriptionTextStyle`, `sectionTitleTextStyle`, plus 11 color properties. |
| `ApplicationType` | Enum: `material`, `cupertino`, `both` — controls how brightness is resolved. |
| `DevicePlatform` | Enum: `android`, `iOS`, `web`, `macOS`, `windows`, `linux`, `fuchsia`. |

## License

MIT — see [LICENSE](LICENSE) for details.
