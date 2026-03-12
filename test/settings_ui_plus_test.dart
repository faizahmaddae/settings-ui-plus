import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:settings_ui_plus/settings_ui_plus.dart';

/// Wraps [child] in a MaterialApp for testing.
Widget materialApp(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

/// Wraps [child] in a dark-themed MaterialApp for testing.
Widget darkMaterialApp(Widget child) {
  return MaterialApp(
    theme: ThemeData.dark(),
    home: Scaffold(body: child),
  );
}

void main() {
  // ---------------------------------------------------------------------------
  // SettingsThemeData
  // ---------------------------------------------------------------------------
  group('SettingsThemeData', () {
    test('default constructor has all null fields', () {
      const data = SettingsThemeData();
      expect(data.settingsListBackground, isNull);
      expect(data.titleTextColor, isNull);
      expect(data.settingsTileTextColor, isNull);
      expect(data.tileHighlightColor, isNull);
      expect(data.leadingIconsColor, isNull);
      expect(data.tileDescriptionTextColor, isNull);
      expect(data.settingsSectionBackground, isNull);
      expect(data.dividerColor, isNull);
      expect(data.trailingTextColor, isNull);
      expect(data.inactiveTitleColor, isNull);
      expect(data.inactiveSubtitleColor, isNull);
    });

    test('copyWith preserves existing values when null is passed', () {
      const original = SettingsThemeData(
        titleTextColor: Colors.red,
        settingsListBackground: Colors.blue,
      );
      final copied = original.copyWith();
      expect(copied.titleTextColor, Colors.red);
      expect(copied.settingsListBackground, Colors.blue);
    });

    test('copyWith overrides provided values', () {
      const original = SettingsThemeData(titleTextColor: Colors.red);
      final copied = original.copyWith(titleTextColor: Colors.green);
      expect(copied.titleTextColor, Colors.green);
    });

    test('merge with null returns same data', () {
      const original = SettingsThemeData(titleTextColor: Colors.red);
      final merged = original.merge(theme: null);
      expect(merged, original);
    });

    test('merge overrides only non-null values from incoming theme', () {
      const base = SettingsThemeData(
        titleTextColor: Colors.red,
        settingsListBackground: Colors.blue,
      );
      const override = SettingsThemeData(titleTextColor: Colors.green);
      final merged = base.merge(theme: override);
      expect(merged.titleTextColor, Colors.green);
      expect(merged.settingsListBackground, Colors.blue);
    });

    test('equality works correctly', () {
      const a = SettingsThemeData(titleTextColor: Colors.red);
      const b = SettingsThemeData(titleTextColor: Colors.red);
      const c = SettingsThemeData(titleTextColor: Colors.blue);
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
      expect(a.hashCode, b.hashCode);
    });
  });

  // ---------------------------------------------------------------------------
  // SettingsList
  // ---------------------------------------------------------------------------
  group('SettingsList', () {
    testWidgets('renders sections', (tester) async {
      await tester.pumpWidget(materialApp(
        const SettingsList(
          sections: [
            SettingsSection(
              title: Text('General'),
              tiles: [
                SettingsTile(
                  title: Text('Language'),
                  leading: Icon(Icons.language),
                ),
              ],
            ),
          ],
        ),
      ));

      expect(find.text('General'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.byIcon(Icons.language), findsOneWidget);
    });

    testWidgets('renders multiple sections and tiles', (tester) async {
      await tester.pumpWidget(materialApp(
        const SettingsList(
          sections: [
            SettingsSection(
              title: Text('Account'),
              tiles: [
                SettingsTile(
                  title: Text('Email'),
                ),
                SettingsTile(
                  title: Text('Phone'),
                ),
              ],
            ),
            SettingsSection(
              title: Text('Security'),
              tiles: [
                SettingsTile(
                  title: Text('Password'),
                ),
              ],
            ),
          ],
        ),
      ));

      expect(find.text('Account'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Phone'), findsOneWidget);
      expect(find.text('Security'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('respects dark theme', (tester) async {
      await tester.pumpWidget(darkMaterialApp(
        const SettingsList(
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile(title: Text('Item')),
              ],
            ),
          ],
        ),
      ));

      expect(find.text('Item'), findsOneWidget);
    });

    testWidgets('applies custom lightTheme override', (tester) async {
      const customBg = Color(0xFFFF0000);

      await tester.pumpWidget(materialApp(
        const SettingsList(
          lightTheme: SettingsThemeData(
            settingsListBackground: customBg,
          ),
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile(title: Text('Themed')),
              ],
            ),
          ],
        ),
      ));

      final coloredBoxes =
          tester.widgetList<ColoredBox>(find.byType(ColoredBox));
      final hasCustomColor = coloredBoxes.any((cb) => cb.color == customBg);
      expect(hasCustomColor, isTrue);
    });

    testWidgets('allows explicit platform override', (tester) async {
      await tester.pumpWidget(materialApp(
        const SettingsList(
          platform: DevicePlatform.iOS,
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile(title: Text('iOS tile')),
              ],
            ),
          ],
        ),
      ));

      expect(find.text('iOS tile'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // SettingsTile variants
  // ---------------------------------------------------------------------------
  group('SettingsTile', () {
    testWidgets('.navigation shows chevron on iOS', (tester) async {
      await tester.pumpWidget(materialApp(
        const SettingsList(
          platform: DevicePlatform.iOS,
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile.navigation(
                  title: Text('Navigate'),
                  leading: Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ],
        ),
      ));

      expect(find.text('Navigate'), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.chevron_forward), findsOneWidget);
    });

    testWidgets('.switchTile renders a Switch on Material', (tester) async {
      bool toggled = false;
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.android,
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile.switchTile(
                  title: const Text('Dark Mode'),
                  initialValue: false,
                  onToggle: (val) => toggled = val,
                ),
              ],
            ),
          ],
        ),
      ));

      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);

      await tester.tap(find.byType(Switch));
      expect(toggled, isTrue);
    });

    testWidgets('.switchTile renders CupertinoSwitch on iOS', (tester) async {
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.iOS,
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile.switchTile(
                  title: const Text('Notifications'),
                  initialValue: true,
                  onToggle: (_) {},
                ),
              ],
            ),
          ],
        ),
      ));

      expect(find.text('Notifications'), findsOneWidget);
      expect(find.byType(CupertinoSwitch), findsOneWidget);
    });

    testWidgets('shows value widget', (tester) async {
      await tester.pumpWidget(materialApp(
        const SettingsList(
          platform: DevicePlatform.android,
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile(
                  title: Text('Language'),
                  value: Text('English'),
                ),
              ],
            ),
          ],
        ),
      ));

      expect(find.text('Language'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
    });

    testWidgets('onPressed fires on tap (Material)', (tester) async {
      var tapped = false;
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.android,
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile(
                  title: const Text('Tap me'),
                  onPressed: (_) => tapped = true,
                ),
              ],
            ),
          ],
        ),
      ));

      await tester.tap(find.text('Tap me'));
      expect(tapped, isTrue);
    });

    testWidgets('disabled tile ignores taps', (tester) async {
      var tapped = false;
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.android,
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile(
                  title: const Text('Disabled'),
                  enabled: false,
                  onPressed: (_) => tapped = true,
                ),
              ],
            ),
          ],
        ),
      ));

      // The tile is wrapped in IgnorePointer(ignoring: true) when disabled.
      final ignorePointer = tester.widget<IgnorePointer>(
        find.ancestor(
          of: find.text('Disabled'),
          matching: find.byType(IgnorePointer),
        ).first,
      );
      expect(ignorePointer.ignoring, isTrue);
      expect(tapped, isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // CustomSettingsTile / CustomSettingsSection
  // ---------------------------------------------------------------------------
  group('Custom widgets', () {
    testWidgets('CustomSettingsTile renders child', (tester) async {
      await tester.pumpWidget(materialApp(
        const SettingsList(
          sections: [
            SettingsSection(
              tiles: [
                CustomSettingsTile(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Custom tile content'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ));

      expect(find.text('Custom tile content'), findsOneWidget);
    });

    testWidgets('CustomSettingsSection renders child', (tester) async {
      await tester.pumpWidget(materialApp(
        const SettingsList(
          sections: [
            CustomSettingsSection(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Custom section content'),
              ),
            ),
          ],
        ),
      ));

      expect(find.text('Custom section content'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // ApplicationType / brightness
  // ---------------------------------------------------------------------------
  group('ApplicationType.cupertino', () {
    testWidgets('renders correctly in CupertinoApp', (tester) async {
      await tester.pumpWidget(
        const CupertinoApp(
          home: SettingsList(
            applicationType: ApplicationType.cupertino,
            platform: DevicePlatform.iOS,
            sections: [
              SettingsSection(
                title: Text('Cupertino'),
                tiles: [
                  SettingsTile(title: Text('Setting')),
                ],
              ),
            ],
          ),
        ),
      );

      expect(find.text('Cupertino'), findsOneWidget);
      expect(find.text('Setting'), findsOneWidget);
    });
  });
}
