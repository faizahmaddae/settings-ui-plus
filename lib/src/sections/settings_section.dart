import 'package:flutter/material.dart';
import 'package:settings_ui_plus/src/sections/abstract_settings_section.dart';
import 'package:settings_ui_plus/src/sections/platforms/ios_settings_section.dart';
import 'package:settings_ui_plus/src/sections/platforms/material_settings_section.dart';
import 'package:settings_ui_plus/src/tiles/abstract_settings_tile.dart';
import 'package:settings_ui_plus/src/utils/platform_utils.dart';
import 'package:settings_ui_plus/src/utils/settings_theme.dart';

class SettingsSection extends AbstractSettingsSection {
  const SettingsSection({
    required this.tiles,
    this.margin,
    this.title,
    super.key,
  });

  final List<AbstractSettingsTile> tiles;
  final EdgeInsetsDirectional? margin;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    final theme = SettingsTheme.of(context);

    switch (theme.platform) {
      case DevicePlatform.android:
      case DevicePlatform.fuchsia:
      case DevicePlatform.linux:
      case DevicePlatform.web:
        return MaterialSettingsSection(
          title: title,
          tiles: tiles,
          margin: margin,
        );
      case DevicePlatform.iOS:
      case DevicePlatform.macOS:
      case DevicePlatform.windows:
        return IOSSettingsSection(
          title: title,
          tiles: tiles,
          margin: margin,
        );
    }
  }
}
