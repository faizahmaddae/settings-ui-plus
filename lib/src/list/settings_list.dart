import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui_plus/src/sections/abstract_settings_section.dart';
import 'package:settings_ui_plus/src/utils/platform_utils.dart';
import 'package:settings_ui_plus/src/utils/settings_list_common.dart';
import 'package:settings_ui_plus/src/utils/settings_theme.dart';

/// Determines how [SettingsList] resolves brightness (light/dark mode).
///
/// This tells the list whether your app uses [MaterialApp], [CupertinoApp],
/// or both, so it queries the correct theme for the current brightness.
enum ApplicationType {
  /// The app uses [MaterialApp]; brightness comes from [ThemeData.brightness].
  material,

  /// The app uses [CupertinoApp]; brightness comes from [CupertinoThemeData].
  cupertino,

  /// The app uses [MaterialApp] on Android and [CupertinoApp] on iOS.
  both,
}

/// A scrollable list of [SettingsSection]s that automatically adapts its
/// appearance to the current platform (Material or Cupertino).
///
/// Wrap your sections in this widget and optionally supply [lightTheme]/
/// [darkTheme] overrides, a forced [platform], or [applicationType] to
/// control brightness resolution.
class SettingsList extends StatelessWidget {
  const SettingsList({
    required this.sections,
    this.shrinkWrap = false,
    this.physics,
    this.platform,
    this.lightTheme,
    this.darkTheme,
    this.brightness,
    this.contentPadding,
    this.applicationType = ApplicationType.material,
    super.key,
  });

  /// Whether the list should shrink-wrap its content.
  final bool shrinkWrap;

  /// Custom scroll physics for the underlying [ListView].
  final ScrollPhysics? physics;

  /// Forces a specific platform appearance instead of auto-detecting.
  final DevicePlatform? platform;

  /// Theme overrides applied when the resolved brightness is [Brightness.light].
  final SettingsThemeData? lightTheme;

  /// Theme overrides applied when the resolved brightness is [Brightness.dark].
  final SettingsThemeData? darkTheme;

  /// Forces a specific brightness instead of reading the app theme.
  final Brightness? brightness;

  /// Custom padding around the list content.
  final EdgeInsetsGeometry? contentPadding;

  /// The sections to display in this settings list.
  final List<AbstractSettingsSection> sections;

  /// Controls how brightness is resolved. Defaults to [ApplicationType.material].
  final ApplicationType applicationType;

  @override
  Widget build(BuildContext context) {
    final platform = this.platform ?? PlatformUtils.detectPlatform(context);

    final brightness = resolveSettingsBrightness(
      explicit: this.brightness,
      platform: platform,
      applicationType: applicationType,
      context: context,
    );

    final themeData = resolveSettingsTheme(
      platform: platform,
      brightness: brightness,
      context: context,
      lightTheme: lightTheme,
      darkTheme: darkTheme,
    );

    return ColoredBox(
      color: themeData.settingsListBackground ?? Colors.transparent,
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: SettingsTheme(
          themeData: themeData,
          platform: platform,
          child: ListView.builder(
            physics: physics,
            shrinkWrap: shrinkWrap,
            itemCount: sections.length,
            padding:
                contentPadding ??
                calculateDefaultSettingsPadding(platform, context),
            itemBuilder: (BuildContext context, int index) {
              return sections[index];
            },
          ),
        ),
      ),
    );
  }
}
