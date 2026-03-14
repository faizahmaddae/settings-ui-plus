import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui_plus/src/list/settings_list.dart';
import 'package:settings_ui_plus/src/utils/platform_utils.dart';
import 'package:settings_ui_plus/src/utils/settings_theme.dart';
import 'package:settings_ui_plus/src/utils/theme_provider.dart';

/// Resolves the effective brightness based on [applicationType] and the
/// ambient [MaterialApp] or [CupertinoApp] theme.
///
/// When [explicit] is non-null it takes precedence.
Brightness resolveSettingsBrightness({
  required Brightness? explicit,
  required DevicePlatform? platform,
  required ApplicationType applicationType,
  required BuildContext context,
}) {
  if (explicit != null) return explicit;

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

/// Builds the merged [SettingsThemeData] for a settings list by combining
/// platform defaults, the app's primary color, and the user's light/dark
/// overrides.
SettingsThemeData resolveSettingsTheme({
  required DevicePlatform platform,
  required Brightness brightness,
  required BuildContext context,
  required SettingsThemeData? lightTheme,
  required SettingsThemeData? darkTheme,
}) {
  final isMaterialPlatform =
      platform != DevicePlatform.iOS && platform != DevicePlatform.macOS;

  return ThemeProvider.getTheme(platform: platform, brightness: brightness)
      .copyWith(
        titleTextColor: isMaterialPlatform
            ? Theme.of(context).colorScheme.primary
            : null,
      )
      .merge(theme: brightness == Brightness.dark ? darkTheme : lightTheme);
}

/// Returns horizontal padding that centres content at a max width of 810.
EdgeInsets calculateDefaultSettingsPadding(
  DevicePlatform platform,
  BuildContext context,
) {
  final isWeb = platform == DevicePlatform.web;
  final width = MediaQuery.sizeOf(context).width;

  if (width > 810) {
    final padding = (width - 810) / 2;
    return EdgeInsets.symmetric(vertical: isWeb ? 20 : 0, horizontal: padding);
  }

  return EdgeInsets.symmetric(vertical: isWeb ? 20 : 0);
}
