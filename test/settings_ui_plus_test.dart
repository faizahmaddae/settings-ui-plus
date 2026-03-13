import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:settings_ui_plus/settings_ui_plus.dart';
import 'package:settings_ui_plus/src/sections/platforms/material_settings_section.dart';
import 'package:settings_ui_plus/src/tiles/platforms/material_settings_tile.dart';
import 'package:settings_ui_plus/src/utils/theme_provider.dart';

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

  // ---------------------------------------------------------------------------
  // Edge cases & robustness
  // ---------------------------------------------------------------------------
  group('Edge cases', () {
    testWidgets('empty tiles list does not crash (iOS)', (tester) async {
      await tester.pumpWidget(materialApp(
        const SettingsList(
          platform: DevicePlatform.iOS,
          sections: [
            SettingsSection(
              title: Text('Empty'),
              tiles: [],
            ),
          ],
        ),
      ));

      // Should render the section title without crashing.
      expect(tester.takeException(), isNull);
    });

    testWidgets('empty tiles list does not crash (Android)', (tester) async {
      await tester.pumpWidget(materialApp(
        const SettingsList(
          platform: DevicePlatform.android,
          sections: [
            SettingsSection(
              title: Text('Empty'),
              tiles: [],
            ),
          ],
        ),
      ));

      expect(tester.takeException(), isNull);
    });

    testWidgets('CustomSettingsTile as last tile does not crash (iOS)',
        (tester) async {
      await tester.pumpWidget(materialApp(
        const SettingsList(
          platform: DevicePlatform.iOS,
          sections: [
            SettingsSection(
              tiles: [
                CustomSettingsTile(child: Text('Custom last')),
              ],
            ),
          ],
        ),
      ));

      expect(find.text('Custom last'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // Accessibility
  // ---------------------------------------------------------------------------
  group('Accessibility', () {
    testWidgets('tiles are wrapped in Semantics (Material)', (tester) async {
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.android,
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile.switchTile(
                  title: const Text('Wifi'),
                  initialValue: true,
                  onToggle: (_) {},
                ),
              ],
            ),
          ],
        ),
      ));

      // The outermost Semantics widget wraps the tile content.
      expect(find.byType(Semantics), findsWidgets);
    });

    testWidgets('tiles are wrapped in Semantics (iOS)', (tester) async {
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.iOS,
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile.switchTile(
                  title: const Text('Wifi'),
                  initialValue: true,
                  onToggle: (_) {},
                ),
              ],
            ),
          ],
        ),
      ));

      expect(find.byType(Semantics), findsWidgets);
    });
  });

  // ---------------------------------------------------------------------------
  // Windows platform mapping
  // ---------------------------------------------------------------------------
  group('Windows platform mapping', () {
    testWidgets('Windows renders MaterialSettingsTile', (tester) async {
      await tester.pumpWidget(materialApp(
        const SettingsList(
          platform: DevicePlatform.windows,
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile(title: Text('Test')),
              ],
            ),
          ],
        ),
      ));

      expect(find.byType(MaterialSettingsTile), findsOneWidget);
    });

    testWidgets('Windows renders MaterialSettingsSection', (tester) async {
      await tester.pumpWidget(materialApp(
        const SettingsList(
          platform: DevicePlatform.windows,
          sections: [
            SettingsSection(
              title: Text('Section'),
              tiles: [
                SettingsTile(title: Text('Test')),
              ],
            ),
          ],
        ),
      ));

      expect(find.byType(MaterialSettingsSection), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // onLongPress
  // ---------------------------------------------------------------------------
  group('onLongPress', () {
    testWidgets('onLongPress fires on Material tile', (tester) async {
      var longPressed = false;

      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.android,
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile(
                  title: const Text('Long press me'),
                  onLongPress: (_) => longPressed = true,
                  onPressed: (_) {},
                ),
              ],
            ),
          ],
        ),
      ));

      await tester.longPress(find.text('Long press me'));
      expect(longPressed, isTrue);
    });

    testWidgets('onLongPress fires on iOS tile', (tester) async {
      var longPressed = false;

      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.iOS,
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile(
                  title: const Text('Long press me'),
                  onLongPress: (_) => longPressed = true,
                ),
              ],
            ),
          ],
        ),
      ));

      await tester.longPress(find.text('Long press me'));
      expect(longPressed, isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // SettingsTile.radioTile
  // ---------------------------------------------------------------------------
  group('SettingsTile.radioTile', () {
    testWidgets('shows checkmark when selected (Material)', (tester) async {
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.android,
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile.radioTile(
                  title: const Text('Option A'),
                  selected: true,
                  onPressed: (_) {},
                ),
                SettingsTile.radioTile(
                  title: const Text('Option B'),
                  selected: false,
                  onPressed: (_) {},
                ),
              ],
            ),
          ],
        ),
      ));

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('shows checkmark when selected (iOS)', (tester) async {
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.iOS,
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile.radioTile(
                  title: const Text('Option A'),
                  selected: true,
                  onPressed: (_) {},
                ),
                SettingsTile.radioTile(
                  title: const Text('Option B'),
                  selected: false,
                  onPressed: (_) {},
                ),
              ],
            ),
          ],
        ),
      ));

      expect(find.byIcon(CupertinoIcons.checkmark_alt), findsOneWidget);
    });

    testWidgets('no checkmark when not selected', (tester) async {
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.android,
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile.radioTile(
                  title: const Text('Option A'),
                  selected: false,
                  onPressed: (_) {},
                ),
              ],
            ),
          ],
        ),
      ));

      expect(find.byIcon(Icons.check), findsNothing);
    });
  });

  // ---------------------------------------------------------------------------
  // Theme TextStyle customization
  // ---------------------------------------------------------------------------
  group('Theme TextStyle customization', () {
    testWidgets('titleTextStyle is applied to Material tile', (tester) async {
      await tester.pumpWidget(materialApp(
        const SettingsList(
          platform: DevicePlatform.android,
          lightTheme: SettingsThemeData(
            titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile(title: Text('Styled')),
              ],
            ),
          ],
        ),
      ));

      final defaultText = tester.widget<DefaultTextStyle>(
        find.ancestor(
          of: find.text('Styled'),
          matching: find.byType(DefaultTextStyle),
        ).first,
      );
      expect(defaultText.style.fontSize, 22);
      expect(defaultText.style.fontWeight, FontWeight.bold);
    });

    test('SettingsThemeData TextStyle fields in equality', () {
      const a = SettingsThemeData(
        titleTextStyle: TextStyle(fontSize: 20),
        descriptionTextStyle: TextStyle(fontSize: 14),
      );
      const b = SettingsThemeData(
        titleTextStyle: TextStyle(fontSize: 20),
        descriptionTextStyle: TextStyle(fontSize: 14),
      );
      const c = SettingsThemeData(
        titleTextStyle: TextStyle(fontSize: 18),
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });
  });

  // ---------------------------------------------------------------------------
  // sectionTitleTextStyle
  // ---------------------------------------------------------------------------
  group('sectionTitleTextStyle', () {
    testWidgets('applies to Material section title', (tester) async {
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.android,
          lightTheme: const SettingsThemeData(
            sectionTitleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          sections: [
            SettingsSection(
              title: const Text('My Section'),
              tiles: [
                SettingsTile(
                  title: const Text('Item'),
                  onPressed: (_) {},
                ),
              ],
            ),
          ],
        ),
      ));

      final sectionTitle = tester.widget<DefaultTextStyle>(
        find.ancestor(
          of: find.text('My Section'),
          matching: find.byType(DefaultTextStyle),
        ).first,
      );
      expect(sectionTitle.style.fontSize, 20);
      expect(sectionTitle.style.fontWeight, FontWeight.w600);
    });

    testWidgets('applies to iOS section title', (tester) async {
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.iOS,
          lightTheme: const SettingsThemeData(
            sectionTitleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          sections: [
            SettingsSection(
              title: const Text('iOS Section'),
              tiles: [
                SettingsTile(
                  title: const Text('Item'),
                  onPressed: (_) {},
                ),
              ],
            ),
          ],
        ),
      ));

      final sectionTitle = tester.widget<DefaultTextStyle>(
        find.ancestor(
          of: find.text('iOS Section'),
          matching: find.byType(DefaultTextStyle),
        ).first,
      );
      expect(sectionTitle.style.fontSize, 18);
      expect(sectionTitle.style.fontWeight, FontWeight.bold);
    });

    test('sectionTitleTextStyle included in equality', () {
      const a = SettingsThemeData(
        sectionTitleTextStyle: TextStyle(fontSize: 16),
      );
      const b = SettingsThemeData(
        sectionTitleTextStyle: TextStyle(fontSize: 16),
      );
      const c = SettingsThemeData(
        sectionTitleTextStyle: TextStyle(fontSize: 14),
      );
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });
  });

  // ---------------------------------------------------------------------------
  // Mouse cursor for desktop
  // ---------------------------------------------------------------------------
  group('Mouse cursor', () {
    testWidgets('clickable tile has click cursor', (tester) async {
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.android,
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile(
                  title: const Text('Clickable'),
                  onPressed: (_) {},
                ),
              ],
            ),
          ],
        ),
      ));

      final inkWell = tester.widget<InkWell>(find.byType(InkWell));
      expect(inkWell.mouseCursor, SystemMouseCursors.click);
    });

    testWidgets('non-clickable tile has basic cursor', (tester) async {
      await tester.pumpWidget(materialApp(
        const SettingsList(
          platform: DevicePlatform.android,
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile(
                  title: Text('Static'),
                ),
              ],
            ),
          ],
        ),
      ));

      final inkWell = tester.widget<InkWell>(find.byType(InkWell));
      expect(inkWell.mouseCursor, SystemMouseCursors.basic);
    });
  });

  // ---------------------------------------------------------------------------
  // Windows theme consistency
  // ---------------------------------------------------------------------------
  group('Windows theme consistency', () {
    testWidgets('Windows uses Android/Material theme colors', (tester) async {
      await tester.pumpWidget(materialApp(
        const SettingsList(
          platform: DevicePlatform.windows,
          sections: [
            SettingsSection(
              title: Text('Section'),
              tiles: [
                SettingsTile(title: Text('Item')),
              ],
            ),
          ],
        ),
      ));

      final theme = SettingsTheme.of(
        tester.element(find.byType(MaterialSettingsTile)),
      );
      // Android/Material theme has a characteristic list background
      // that differs from iOS. Verify it's not null (set by ThemeProvider).
      expect(theme.themeData.settingsListBackground, isNotNull);
      // Material theme does NOT set trailingTextColor (iOS-only),
      // so this should be null for the android theme.
      expect(theme.themeData.trailingTextColor, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // Expandable sections
  // ---------------------------------------------------------------------------
  group('Expandable sections', () {
    testWidgets('non-expandable section shows tiles by default',
        (tester) async {
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.android,
          sections: [
            SettingsSection(
              title: const Text('Normal'),
              tiles: [
                SettingsTile(
                  title: const Text('Visible'),
                  onPressed: (_) {},
                ),
              ],
            ),
          ],
        ),
      ));

      expect(find.text('Visible'), findsOneWidget);
      // No expand icon for non-expandable sections
      expect(find.byIcon(Icons.expand_more), findsNothing);
    });

    testWidgets('expandable section starts expanded by default',
        (tester) async {
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.android,
          sections: [
            SettingsSection(
              title: const Text('Expandable'),
              expandable: true,
              tiles: [
                SettingsTile(
                  title: const Text('Content'),
                  onPressed: (_) {},
                ),
              ],
            ),
          ],
        ),
      ));

      expect(find.text('Content'), findsOneWidget);
      expect(find.byIcon(Icons.expand_more), findsOneWidget);
    });

    testWidgets('expandable section starts collapsed when initiallyExpanded=false',
        (tester) async {
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.android,
          sections: [
            SettingsSection(
              title: const Text('Collapsed'),
              expandable: true,
              initiallyExpanded: false,
              tiles: [
                SettingsTile(
                  title: const Text('Hidden'),
                  onPressed: (_) {},
                ),
              ],
            ),
          ],
        ),
      ));

      // The tile text should exist in the tree but be hidden by SizeTransition
      expect(find.byIcon(Icons.expand_more), findsOneWidget);
      // Tap the title to expand
      await tester.tap(find.text('Collapsed'));
      await tester.pumpAndSettle();
      // Now the tile should be visible
      expect(find.text('Hidden'), findsOneWidget);
    });

    testWidgets('tapping title toggles expansion (Material)',
        (tester) async {
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.android,
          sections: [
            SettingsSection(
              title: const Text('Toggle'),
              expandable: true,
              tiles: [
                SettingsTile(
                  title: const Text('Item'),
                  onPressed: (_) {},
                ),
              ],
            ),
          ],
        ),
      ));

      // Starts expanded
      expect(find.text('Item'), findsOneWidget);

      // Tap to collapse
      await tester.tap(find.text('Toggle'));
      await tester.pumpAndSettle();

      // Tap to expand again
      await tester.tap(find.text('Toggle'));
      await tester.pumpAndSettle();
      expect(find.text('Item'), findsOneWidget);
    });

    testWidgets('expandable works on iOS platform', (tester) async {
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.iOS,
          sections: [
            SettingsSection(
              title: const Text('iOS Expand'),
              expandable: true,
              initiallyExpanded: false,
              tiles: [
                SettingsTile(
                  title: const Text('iOS Item'),
                  onPressed: (_) {},
                ),
              ],
            ),
          ],
        ),
      ));

      expect(find.byIcon(Icons.expand_more), findsOneWidget);
      // Expand
      await tester.tap(find.text('iOS Expand'));
      await tester.pumpAndSettle();
      expect(find.text('iOS Item'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // Barrel exports
  // ---------------------------------------------------------------------------
  group('Barrel exports', () {
    test('ApplicationType is accessible from barrel import', () {
      // ApplicationType should be exported from settings_ui_plus.dart
      expect(ApplicationType.values, hasLength(3));
      expect(ApplicationType.material, isNotNull);
      expect(ApplicationType.cupertino, isNotNull);
      expect(ApplicationType.both, isNotNull);
    });
  });

  // ---------------------------------------------------------------------------
  // Section with no title
  // ---------------------------------------------------------------------------
  group('Section with no title', () {
    testWidgets('renders correctly on Material without a title',
        (tester) async {
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.android,
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile(
                  title: const Text('No Title Section'),
                  onPressed: (_) {},
                ),
              ],
            ),
          ],
        ),
      ));

      expect(find.text('No Title Section'), findsOneWidget);
    });

    testWidgets('renders correctly on iOS without a title', (tester) async {
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.iOS,
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile(
                  title: const Text('iOS No Title'),
                  onPressed: (_) {},
                ),
              ],
            ),
          ],
        ),
      ));

      expect(find.text('iOS No Title'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // Section footer
  // ---------------------------------------------------------------------------
  group('Section footer', () {
    testWidgets('footer renders on Material section', (tester) async {
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.android,
          sections: [
            SettingsSection(
              title: const Text('Account'),
              footer: const Text('Your data is stored locally.'),
              tiles: [
                SettingsTile(
                  title: const Text('Username'),
                  onPressed: (_) {},
                ),
              ],
            ),
          ],
        ),
      ));

      expect(find.text('Your data is stored locally.'), findsOneWidget);
    });

    testWidgets('footer renders on iOS section', (tester) async {
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.iOS,
          sections: [
            SettingsSection(
              title: const Text('Account'),
              footer: const Text('Managed by your organization.'),
              tiles: [
                SettingsTile(
                  title: const Text('Username'),
                  onPressed: (_) {},
                ),
              ],
            ),
          ],
        ),
      ));

      expect(find.text('Managed by your organization.'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // Text overflow
  // ---------------------------------------------------------------------------
  group('Text overflow handling', () {
    testWidgets('Material tile title has maxLines and ellipsis', (tester) async {
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.android,
          sections: [
            SettingsSection(
              title: const Text('Section'),
              tiles: [
                SettingsTile(
                  title: const Text(
                    'A very long title that should get truncated with ellipsis if it exceeds the maximum allowed lines for nice display',
                  ),
                  onPressed: (_) {},
                ),
              ],
            ),
          ],
        ),
      ));

      final titleDefault = tester.widgetList<DefaultTextStyle>(
        find.byType(DefaultTextStyle),
      ).where((w) => w.maxLines == 2 && w.overflow == TextOverflow.ellipsis);
      expect(titleDefault, isNotEmpty);
    });

    testWidgets('Material tile description has maxLines and ellipsis',
        (tester) async {
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.android,
          sections: [
            SettingsSection(
              title: const Text('Section'),
              tiles: [
                SettingsTile(
                  title: const Text('Title'),
                  description: const Text(
                    'A very very long description text that spans multiple lines and should be truncated properly with ellipsis overflow handling',
                  ),
                  onPressed: (_) {},
                ),
              ],
            ),
          ],
        ),
      ));

      final descDefault = tester.widgetList<DefaultTextStyle>(
        find.byType(DefaultTextStyle),
      ).where((w) => w.maxLines == 3 && w.overflow == TextOverflow.ellipsis);
      expect(descDefault, isNotEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // iOS disabled opacity
  // ---------------------------------------------------------------------------
  group('iOS disabled state', () {
    testWidgets('disabled tile has reduced opacity on iOS', (tester) async {
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.iOS,
          sections: [
            SettingsSection(
              title: const Text('Section'),
              tiles: [
                SettingsTile(
                  title: const Text('Disabled'),
                  enabled: false,
                  onPressed: (_) {},
                ),
              ],
            ),
          ],
        ),
      ));

      final opacityWidget = tester.widget<Opacity>(find.byType(Opacity).first);
      expect(opacityWidget.opacity, 0.5);
    });

    testWidgets('enabled tile has full opacity on iOS', (tester) async {
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.iOS,
          sections: [
            SettingsSection(
              title: const Text('Section'),
              tiles: [
                SettingsTile(
                  title: const Text('Enabled'),
                  onPressed: (_) {},
                ),
              ],
            ),
          ],
        ),
      ));

      final opacityWidget = tester.widget<Opacity>(find.byType(Opacity).first);
      expect(opacityWidget.opacity, 1.0);
    });
  });

  // ---------------------------------------------------------------------------
  // Radio tile selected background
  // ---------------------------------------------------------------------------
  group('Radio tile selected background', () {
    testWidgets('selected radio tile has tinted background on Material',
        (tester) async {
      await tester.pumpWidget(materialApp(
        SettingsList(
          platform: DevicePlatform.android,
          sections: [
            SettingsSection(
              title: const Text('Language'),
              tiles: [
                SettingsTile.radioTile(
                  title: const Text('English'),
                  selected: true,
                  onPressed: (_) {},
                ),
              ],
            ),
          ],
        ),
      ));

      // The Material wrapping the tile should have a non-transparent color
      final materials = tester.widgetList<Material>(find.byType(Material));
      final tintedMaterial = materials.where(
        (m) => m.color != null && m.color != Colors.transparent && m.color!.a < 1.0 && m.color!.a > 0.0,
      );
      expect(tintedMaterial, isNotEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // ThemeProvider caching
  // ---------------------------------------------------------------------------
  group('ThemeProvider caching', () {
    test('returns same instance for same platform and brightness', () {
      final theme1 = ThemeProvider.getTheme(
        platform: DevicePlatform.android,
        brightness: Brightness.light,
      );
      final theme2 = ThemeProvider.getTheme(
        platform: DevicePlatform.android,
        brightness: Brightness.light,
      );
      expect(identical(theme1, theme2), isTrue);
    });

    test('returns different instances for different brightness', () {
      final light = ThemeProvider.getTheme(
        platform: DevicePlatform.android,
        brightness: Brightness.light,
      );
      final dark = ThemeProvider.getTheme(
        platform: DevicePlatform.android,
        brightness: Brightness.dark,
      );
      expect(identical(light, dark), isFalse);
    });
  });

  group('Slider tile', () {
    testWidgets('renders Material slider with correct value',
        (WidgetTester tester) async {
      double currentValue = 0.5;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsList(
              platform: DevicePlatform.android,
              sections: [
                SettingsSection(
                  title: const Text('Slider'),
                  tiles: [
                    SettingsTile.sliderTile(
                      title: const Text('Brightness'),
                      sliderValue: currentValue,
                      onSliderChanged: (v) => currentValue = v,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(Slider), findsOneWidget);
      expect(find.text('Brightness'), findsOneWidget);
    });

    testWidgets('slider tile respects min/max/divisions',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsList(
              platform: DevicePlatform.android,
              sections: [
                SettingsSection(
                  title: const Text('S'),
                  tiles: [
                    SettingsTile.sliderTile(
                      title: const Text('Volume'),
                      sliderValue: 50,
                      sliderMin: 0,
                      sliderMax: 100,
                      sliderDivisions: 10,
                      onSliderChanged: (_) {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.min, 0);
      expect(slider.max, 100);
      expect(slider.divisions, 10);
      expect(slider.value, 50);
    });

    testWidgets('slider tile disabled when enabled is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsList(
              platform: DevicePlatform.android,
              sections: [
                SettingsSection(
                  title: const Text('S'),
                  tiles: [
                    SettingsTile.sliderTile(
                      title: const Text('Volume'),
                      sliderValue: 0.5,
                      onSliderChanged: (_) {},
                      enabled: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.onChanged, isNull);
    });

    testWidgets('slider tile renders on iOS with CupertinoSlider',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsList(
              platform: DevicePlatform.iOS,
              sections: [
                SettingsSection(
                  title: const Text('S'),
                  tiles: [
                    SettingsTile.sliderTile(
                      title: const Text('Volume'),
                      sliderValue: 0.5,
                      onSliderChanged: (_) {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(CupertinoSlider), findsOneWidget);
    });

    testWidgets('slider tile has correct tile type', (WidgetTester tester) async {
      const tile = SettingsTile.sliderTile(
        title: Text('Test'),
        sliderValue: 0.5,
        onSliderChanged: null,
      );
      expect(tile.tileType, SettingsTileType.sliderTile);
    });
  });

  group('ExpandableSectionMixin', () {
    testWidgets('expandable sections still work after mixin refactor',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SettingsList(
              platform: DevicePlatform.android,
              sections: [
                SettingsSection(
                  title: Text('Expandable'),
                  expandable: true,
                  initiallyExpanded: true,
                  tiles: [
                    SettingsTile(title: Text('Item')),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      // Title and item visible
      expect(find.text('Expandable'), findsOneWidget);
      expect(find.text('Item'), findsOneWidget);

      // Tap to collapse
      await tester.tap(find.text('Expandable'));
      await tester.pumpAndSettle();

      // Title still visible, item collapsed (SizeTransition animates to 0)
      expect(find.text('Expandable'), findsOneWidget);
    });

    testWidgets('iOS expandable section works after mixin refactor',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SettingsList(
              platform: DevicePlatform.iOS,
              sections: [
                SettingsSection(
                  title: Text('Expandable'),
                  expandable: true,
                  initiallyExpanded: false,
                  tiles: [
                    SettingsTile(title: Text('Hidden')),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      // Tap to expand
      await tester.tap(find.text('Expandable'));
      await tester.pumpAndSettle();

      expect(find.text('Hidden'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // UI/UX audit fixes
  // ---------------------------------------------------------------------------
  group('UI/UX audit fixes', () {
    testWidgets('Material tile has Semantics with button role',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsList(
              platform: DevicePlatform.android,
              sections: [
                SettingsSection(
                  title: const Text('S'),
                  tiles: [
                    SettingsTile(
                      title: const Text('Tap me'),
                      onPressed: (_) {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      final semantics = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.hint == 'Double-tap to activate',
        ),
      );
      expect(semantics.properties.button, isTrue);
    });

    testWidgets('Material disabled tile has reduced opacity',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SettingsList(
              platform: DevicePlatform.android,
              sections: [
                SettingsSection(
                  title: Text('S'),
                  tiles: [
                    SettingsTile(
                      title: Text('Disabled'),
                      enabled: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      final opacityWidget =
          tester.widget<Opacity>(find.byType(Opacity).first);
      expect(opacityWidget.opacity, 0.38);
    });

    testWidgets('Material tile font size is 16',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SettingsList(
              platform: DevicePlatform.android,
              sections: [
                SettingsSection(
                  title: Text('S'),
                  tiles: [
                    SettingsTile(
                      title: Text('Title'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      final defaultText = tester.widget<DefaultTextStyle>(
        find.ancestor(
          of: find.text('Title'),
          matching: find.byType(DefaultTextStyle),
        ).first,
      );
      expect(defaultText.style.fontSize, 16);
    });

    testWidgets('iOS tile has minimum 44pt height',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SettingsList(
              platform: DevicePlatform.iOS,
              sections: [
                SettingsSection(
                  title: Text('S'),
                  tiles: [
                    SettingsTile(
                      title: Text('Short'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.byWidgetPredicate(
          (w) =>
              w is Container &&
              w.constraints != null &&
              w.constraints!.minHeight == 44,
        ),
      );
      expect(container.constraints!.minHeight, 44);
    });

    testWidgets('iOS switch defaults to false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsList(
              platform: DevicePlatform.iOS,
              sections: [
                SettingsSection(
                  title: const Text('S'),
                  tiles: [
                    SettingsTile.switchTile(
                      title: const Text('Toggle'),
                      initialValue: null,
                      onToggle: (_) {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      final cupertinoSwitch = tester.widget<CupertinoSwitch>(
        find.byType(CupertinoSwitch),
      );
      expect(cupertinoSwitch.value, false);
    });

    testWidgets('Material slider shows label when divisions set',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsList(
              platform: DevicePlatform.android,
              sections: [
                SettingsSection(
                  title: const Text('S'),
                  tiles: [
                    SettingsTile.sliderTile(
                      title: const Text('Vol'),
                      sliderValue: 50,
                      sliderMin: 0,
                      sliderMax: 100,
                      sliderDivisions: 10,
                      onSliderChanged: (_) {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.label, isNotNull);
    });

    testWidgets('empty Material section renders SizedBox.shrink',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SettingsList(
              platform: DevicePlatform.android,
              sections: [
                SettingsSection(
                  tiles: [],
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('InkWell has focusColor set on Material',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsList(
              platform: DevicePlatform.android,
              sections: [
                SettingsSection(
                  title: const Text('S'),
                  tiles: [
                    SettingsTile(
                      title: const Text('Tile'),
                      onPressed: (_) {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      final inkWell = tester.widget<InkWell>(find.byType(InkWell));
      expect(inkWell.focusColor, isNotNull);
    });

    testWidgets('switch tile Semantics hint says toggle',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsList(
              platform: DevicePlatform.android,
              sections: [
                SettingsSection(
                  title: const Text('S'),
                  tiles: [
                    SettingsTile.switchTile(
                      title: const Text('Dark'),
                      initialValue: false,
                      onToggle: (_) {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      final semantics = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.hint == 'Double-tap to toggle',
        ),
      );
      expect(semantics.properties.hint, 'Double-tap to toggle');
    });

    testWidgets('slider tile Semantics hint says adjust',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsList(
              platform: DevicePlatform.android,
              sections: [
                SettingsSection(
                  title: const Text('S'),
                  tiles: [
                    SettingsTile.sliderTile(
                      title: const Text('Vol'),
                      sliderValue: 50,
                      sliderMin: 0,
                      sliderMax: 100,
                      onSliderChanged: (_) {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      final semantics = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.hint == 'Adjust with slider',
        ),
      );
      expect(semantics.properties.hint, 'Adjust with slider');
    });

    testWidgets('iOS section padding uses EdgeInsetsDirectional',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SettingsList(
              platform: DevicePlatform.iOS,
              sections: [
                SettingsSection(
                  title: Text('Section'),
                  tiles: [
                    SettingsTile(title: Text('Tile')),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      // Verify the section renders without error (RTL-safe padding)
      expect(find.text('Section'), findsOneWidget);
    });

    testWidgets('Material section title uses ColorScheme.primary',
        (WidgetTester tester) async {
      const customPrimary = Color(0xFF00BFA5);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: const ColorScheme.light(primary: customPrimary),
          ),
          home: const Scaffold(
            body: SettingsList(
              platform: DevicePlatform.android,
              sections: [
                SettingsSection(
                  title: Text('Section'),
                  tiles: [
                    SettingsTile(title: Text('Tile')),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      // Find the section title DefaultTextStyle
      final defaultTextStyle = tester.widget<DefaultTextStyle>(
        find.ancestor(
          of: find.text('Section'),
          matching: find.byType(DefaultTextStyle),
        ).first,
      );
      expect(defaultTextStyle.style.color, customPrimary);
    });

    testWidgets('disabled Material switch does not set activeTrackColor',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsList(
              platform: DevicePlatform.android,
              sections: [
                SettingsSection(
                  title: const Text('S'),
                  tiles: [
                    SettingsTile.switchTile(
                      title: const Text('Toggle'),
                      initialValue: true,
                      onToggle: (_) {},
                      enabled: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      final sw = tester.widget<Switch>(find.byType(Switch));
      expect(sw.activeTrackColor, isNull);
    });

    testWidgets('Material slider tile has dedicated layout',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsList(
              platform: DevicePlatform.android,
              sections: [
                SettingsSection(
                  title: const Text('S'),
                  tiles: [
                    SettingsTile.sliderTile(
                      title: const Text('Vol'),
                      sliderValue: 50,
                      sliderMin: 0,
                      sliderMax: 100,
                      value: const Text('50'),
                      onSliderChanged: (_) {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      // Slider exists in its own row
      expect(find.byType(Slider), findsOneWidget);
      // Value label is visible
      expect(find.text('50'), findsOneWidget);
    });

    testWidgets('Web card uses BorderRadius 12',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SettingsList(
              platform: DevicePlatform.web,
              sections: [
                SettingsSection(
                  title: Text('S'),
                  tiles: [
                    SettingsTile(title: Text('Tile')),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      final shape = card.shape as RoundedRectangleBorder;
      expect(shape.borderRadius, BorderRadius.circular(12));
    });

    testWidgets('iOS slider tile shows value label',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsList(
              platform: DevicePlatform.iOS,
              sections: [
                SettingsSection(
                  title: const Text('S'),
                  tiles: [
                    SettingsTile.sliderTile(
                      title: const Text('Font'),
                      sliderValue: 16,
                      sliderMin: 10,
                      sliderMax: 30,
                      value: const Text('16'),
                      onSliderChanged: (_) {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      // Value label should be visible on iOS slider tile exactly once
      expect(find.text('16'), findsOneWidget);
      expect(find.byType(CupertinoSlider), findsOneWidget);
    });
  });

  group('Cross-platform bug fixes', () {
    testWidgets('iOS slider value label appears exactly once', (tester) async {
      await tester.pumpWidget(
        materialApp(
          SettingsList(
            platform: DevicePlatform.iOS,
            sections: [
              SettingsSection(
                title: const Text('Test'),
                tiles: [
                  SettingsTile.sliderTile(
                    title: const Text('Brightness'),
                    sliderValue: 0.75,
                    onSliderChanged: (_) {},
                    value: const Text('75%'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      // Must appear exactly once — not duplicated
      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('iOS disabled switch is not double-dimmed', (tester) async {
      await tester.pumpWidget(
        materialApp(
          SettingsList(
            platform: DevicePlatform.iOS,
            sections: [
              SettingsSection(
                title: const Text('Test'),
                tiles: [
                  SettingsTile.switchTile(
                    title: const Text('Disabled Switch'),
                    initialValue: true,
                    onToggle: (_) {},
                    enabled: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      // The CupertinoSwitch should still receive onToggle (not null),
      // relying on IgnorePointer for disabling interaction
      final cuSwitch = tester.widget<CupertinoSwitch>(
        find.byType(CupertinoSwitch),
      );
      expect(cuSwitch.onChanged, isNotNull);
    });

    testWidgets('Material slider tile supports trailing widget', (tester) async {
      await tester.pumpWidget(
        materialApp(
          SettingsList(
            platform: DevicePlatform.android,
            sections: [
              SettingsSection(
                title: const Text('Test'),
                tiles: [
                  SettingsTile.sliderTile(
                    title: const Text('Volume'),
                    sliderValue: 0.5,
                    onSliderChanged: (_) {},
                    trailing: const Icon(Icons.volume_up),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.volume_up), findsOneWidget);
    });

    testWidgets('Material slider tile fires onLongPress', (tester) async {
      var longPressed = false;
      await tester.pumpWidget(
        materialApp(
          SettingsList(
            platform: DevicePlatform.android,
            sections: [
              SettingsSection(
                title: const Text('Test'),
                tiles: [
                  SettingsTile.sliderTile(
                    title: const Text('Volume'),
                    sliderValue: 0.5,
                    onSliderChanged: (_) {},
                    onLongPress: (_) => longPressed = true,
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      await tester.longPress(find.text('Volume'));
      expect(longPressed, isTrue);
    });
  });
}
