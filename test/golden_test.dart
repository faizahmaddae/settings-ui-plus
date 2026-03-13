@Tags(['golden'])
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:settings_ui_plus/settings_ui_plus.dart';

/// Wraps [child] in a surface-sized MaterialApp for golden screenshots.
Widget goldenApp(Widget child, {Brightness brightness = Brightness.light}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: brightness,
      ),
      useMaterial3: true,
    ),
    home: Scaffold(body: RepaintBoundary(child: child)),
  );
}

/// A set of reusable sections that exercise every tile type.
List<AbstractSettingsSection> _sampleSections() {
  return [
    SettingsSection(
      title: const Text('Account'),
      tiles: [
        const SettingsTile.navigation(
          title: Text('Profile'),
          leading: Icon(Icons.person),
          value: Text('Alex'),
        ),
        const SettingsTile.switchTile(
          title: Text('Dark Mode'),
          leading: Icon(Icons.dark_mode_outlined),
          initialValue: false,
          onToggle: null,
        ),
        const SettingsTile.sliderTile(
          title: Text('Volume'),
          sliderValue: 0.6,
          sliderMin: 0,
          sliderMax: 1,
          onSliderChanged: null,
          value: Text('60%'),
        ),
        SettingsTile.dropdownTile(
          title: const Text('Language'),
          dropdownItems: const [
            DropdownSettingsItem(value: 'en', child: Text('English')),
            DropdownSettingsItem(value: 'fr', child: Text('French')),
          ],
          dropdownValue: 'en',
          onDropdownChanged: (_) {},
        ),
        const SettingsTile.radioTile(title: Text('Option A'), selected: true),
      ],
    ),
  ];
}

void main() {
  // -----------------------------------------------------------------------
  // Material – Light
  // -----------------------------------------------------------------------
  group('Golden – Material Light', () {
    testWidgets('settings list', (tester) async {
      await tester.pumpWidget(
        goldenApp(SettingsList(sections: _sampleSections())),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(SettingsList),
        matchesGoldenFile('goldens/material_light.png'),
      );
    });
  });

  // -----------------------------------------------------------------------
  // Material – Dark
  // -----------------------------------------------------------------------
  group('Golden – Material Dark', () {
    testWidgets('settings list', (tester) async {
      await tester.pumpWidget(
        goldenApp(
          SettingsList(
            brightness: Brightness.dark,
            sections: _sampleSections(),
          ),
          brightness: Brightness.dark,
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(SettingsList),
        matchesGoldenFile('goldens/material_dark.png'),
      );
    });
  });

  // -----------------------------------------------------------------------
  // iOS – Light
  // -----------------------------------------------------------------------
  group('Golden – iOS Light', () {
    testWidgets('settings list', (tester) async {
      await tester.pumpWidget(
        goldenApp(
          SettingsList(
            platform: DevicePlatform.iOS,
            sections: _sampleSections(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(SettingsList),
        matchesGoldenFile('goldens/ios_light.png'),
      );
    });
  });

  // -----------------------------------------------------------------------
  // iOS – Dark
  // -----------------------------------------------------------------------
  group('Golden – iOS Dark', () {
    testWidgets('settings list', (tester) async {
      await tester.pumpWidget(
        goldenApp(
          SettingsList(
            platform: DevicePlatform.iOS,
            brightness: Brightness.dark,
            sections: _sampleSections(),
          ),
          brightness: Brightness.dark,
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(SettingsList),
        matchesGoldenFile('goldens/ios_dark.png'),
      );
    });
  });
}
