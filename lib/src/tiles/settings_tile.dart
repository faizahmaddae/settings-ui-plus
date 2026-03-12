import 'package:flutter/material.dart';
import 'package:settings_ui_plus/src/tiles/abstract_settings_tile.dart';
import 'package:settings_ui_plus/src/tiles/platforms/ios_settings_tile.dart';
import 'package:settings_ui_plus/src/tiles/platforms/material_settings_tile.dart';
import 'package:settings_ui_plus/src/utils/platform_utils.dart';
import 'package:settings_ui_plus/src/utils/settings_theme.dart';

enum SettingsTileType { simpleTile, switchTile, navigationTile }

class SettingsTile extends AbstractSettingsTile {
  const SettingsTile({
    this.leading,
    this.trailing,
    this.value,
    required this.title,
    this.description,
    this.onPressed,
    this.enabled = true,
    super.key,
  })  : onToggle = null,
        initialValue = null,
        activeSwitchColor = null,
        tileType = SettingsTileType.simpleTile;

  const SettingsTile.navigation({
    this.leading,
    this.trailing,
    this.value,
    required this.title,
    this.description,
    this.onPressed,
    this.enabled = true,
    super.key,
  })  : onToggle = null,
        initialValue = null,
        activeSwitchColor = null,
        tileType = SettingsTileType.navigationTile;

  const SettingsTile.switchTile({
    required this.initialValue,
    required this.onToggle,
    this.activeSwitchColor,
    this.leading,
    this.trailing,
    required this.title,
    this.description,
    this.onPressed,
    this.enabled = true,
    super.key,
  })  : value = null,
        tileType = SettingsTileType.switchTile;

  /// The widget at the beginning of the tile
  final Widget? leading;

  /// The Widget at the end of the tile
  final Widget? trailing;

  /// The widget at the center of the tile
  final Widget title;

  /// The widget at the bottom of the [title]
  final Widget? description;

  /// A function that is called by tap on a tile
  final Function(BuildContext context)? onPressed;

  final Color? activeSwitchColor;
  final Widget? value;
  final Function(bool value)? onToggle;
  final SettingsTileType tileType;
  final bool? initialValue;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = SettingsTheme.of(context);

    switch (theme.platform) {
      case DevicePlatform.android:
      case DevicePlatform.fuchsia:
      case DevicePlatform.linux:
      case DevicePlatform.web:
        return MaterialSettingsTile(
          description: description,
          onPressed: onPressed,
          onToggle: onToggle,
          tileType: tileType,
          value: value,
          leading: leading,
          title: title,
          enabled: enabled,
          activeSwitchColor: activeSwitchColor,
          initialValue: initialValue ?? false,
          trailing: trailing,
        );
      case DevicePlatform.iOS:
      case DevicePlatform.macOS:
      case DevicePlatform.windows:
        return IOSSettingsTile(
          description: description,
          onPressed: onPressed,
          onToggle: onToggle,
          tileType: tileType,
          value: value,
          leading: leading,
          title: title,
          trailing: trailing,
          enabled: enabled,
          activeSwitchColor: activeSwitchColor,
          initialValue: initialValue ?? false,
        );
    }
  }
}
