import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui_plus/src/sections/abstract_settings_section.dart';
import 'package:settings_ui_plus/src/utils/platform_utils.dart';
import 'package:settings_ui_plus/src/utils/settings_theme.dart';
import 'package:settings_ui_plus/src/utils/theme_provider.dart';

enum ApplicationType {
  /// Use this parameter is you are using the MaterialApp
  material,

  /// Use this parameter is you are using the CupertinoApp
  cupertino,

  /// Use this parameter is you are using the MaterialApp for Android
  /// and the CupertinoApp for iOS.
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

  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final DevicePlatform? platform;
  final SettingsThemeData? lightTheme;
  final SettingsThemeData? darkTheme;
  final Brightness? brightness;
  final EdgeInsetsGeometry? contentPadding;
  final List<AbstractSettingsSection> sections;
  final ApplicationType applicationType;

  @override
  Widget build(BuildContext context) {
    final platform = this.platform ?? PlatformUtils.detectPlatform(context);

    final brightness = calculateBrightness(context);

    // Use the app's ColorScheme.primary for Material section titles so they
    // adapt to the app's theme instead of using a hardcoded blue.
    final isMaterialPlatform =
        platform != DevicePlatform.iOS && platform != DevicePlatform.macOS;

    final themeData =
        ThemeProvider.getTheme(platform: platform, brightness: brightness)
            .copyWith(
              titleTextColor: isMaterialPlatform
                  ? Theme.of(context).colorScheme.primary
                  : null,
            )
            .merge(
              theme: brightness == Brightness.dark ? darkTheme : lightTheme,
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
                contentPadding ?? calculateDefaultPadding(platform, context),
            itemBuilder: (BuildContext context, int index) {
              return sections[index];
            },
          ),
        ),
      ),
    );
  }

  EdgeInsets calculateDefaultPadding(
    DevicePlatform platform,
    BuildContext context,
  ) {
    final isWeb = platform == DevicePlatform.web;
    final width = MediaQuery.sizeOf(context).width;

    if (width > 810) {
      final padding = (width - 810) / 2;
      return EdgeInsets.symmetric(
        vertical: isWeb ? 20 : 0,
        horizontal: padding,
      );
    }

    return EdgeInsets.symmetric(vertical: isWeb ? 20 : 0);
  }

  Brightness calculateBrightness(BuildContext context) {
    final materialBrightness = Theme.of(context).brightness;
    final cupertinoBrightness =
        CupertinoTheme.of(context).brightness ??
        MediaQuery.of(context).platformBrightness;

    switch (applicationType) {
      case ApplicationType.material:
        return materialBrightness;
      case ApplicationType.cupertino:
        return cupertinoBrightness;
      case ApplicationType.both:
        return platform != DevicePlatform.iOS
            ? materialBrightness
            : cupertinoBrightness;
    }
  }
}
