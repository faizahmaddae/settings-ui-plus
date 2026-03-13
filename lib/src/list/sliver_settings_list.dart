import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui_plus/src/list/settings_list.dart';
import 'package:settings_ui_plus/src/sections/abstract_settings_section.dart';
import 'package:settings_ui_plus/src/utils/platform_utils.dart';
import 'package:settings_ui_plus/src/utils/settings_theme.dart';
import 'package:settings_ui_plus/src/utils/theme_provider.dart';

/// A sliver-compatible variant of [SettingsList].
///
/// Use this inside a [CustomScrollView] when you need to combine settings
/// sections with other slivers (e.g. a [SliverAppBar]).
///
/// ```dart
/// CustomScrollView(
///   slivers: [
///     SliverAppBar(title: Text('Settings')),
///     SliverSettingsList(
///       sections: [ ... ],
///     ),
///   ],
/// )
/// ```
class SliverSettingsList extends StatelessWidget {
  const SliverSettingsList({
    required this.sections,
    this.platform,
    this.lightTheme,
    this.darkTheme,
    this.brightness,
    this.contentPadding,
    this.applicationType = ApplicationType.material,
    super.key,
  });

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

  /// The sections to display.
  final List<AbstractSettingsSection> sections;

  /// Controls how brightness is resolved.
  final ApplicationType applicationType;

  @override
  Widget build(BuildContext context) {
    final resolvedPlatform = platform ?? PlatformUtils.detectPlatform(context);

    final resolvedBrightness = _calculateBrightness(context);

    final isMaterialPlatform =
        resolvedPlatform != DevicePlatform.iOS &&
        resolvedPlatform != DevicePlatform.macOS;

    final themeData =
        ThemeProvider.getTheme(
              platform: resolvedPlatform,
              brightness: resolvedBrightness,
            )
            .copyWith(
              titleTextColor: isMaterialPlatform
                  ? Theme.of(context).colorScheme.primary
                  : null,
            )
            .merge(
              theme: resolvedBrightness == Brightness.dark
                  ? darkTheme
                  : lightTheme,
            );

    final padding =
        contentPadding ?? _calculateDefaultPadding(resolvedPlatform, context);

    return SliverPadding(
      padding: padding,
      sliver: SliverList.builder(
        itemCount: sections.length,
        itemBuilder: (context, index) {
          return SettingsTheme(
            themeData: themeData,
            platform: resolvedPlatform,
            child: sections[index],
          );
        },
      ),
    );
  }

  EdgeInsets _calculateDefaultPadding(
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

  Brightness _calculateBrightness(BuildContext context) {
    if (brightness != null) return brightness!;

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
