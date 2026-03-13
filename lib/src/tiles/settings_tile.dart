import 'package:flutter/material.dart';
import 'package:settings_ui_plus/src/tiles/abstract_settings_tile.dart';
import 'package:settings_ui_plus/src/tiles/platforms/ios_settings_tile.dart';
import 'package:settings_ui_plus/src/tiles/platforms/material_settings_tile.dart';
import 'package:settings_ui_plus/src/utils/platform_utils.dart';
import 'package:settings_ui_plus/src/utils/settings_theme.dart';

/// The visual type of a [SettingsTile].
enum SettingsTileType { simpleTile, switchTile, navigationTile, sliderTile }

/// A single settings row that adapts to Material or Cupertino styling.
///
/// Use the named constructors for common variants:
/// - [SettingsTile.navigation] — shows a trailing chevron.
/// - [SettingsTile.switchTile] — shows a toggle switch.
/// - [SettingsTile.radioTile] — shows a checkmark when [selected].
class SettingsTile extends AbstractSettingsTile {
  /// Creates a basic settings tile with a [title] and optional [leading],
  /// [trailing], [value], and [description] widgets.
  const SettingsTile({
    this.leading,
    this.trailing,
    this.value,
    required this.title,
    this.description,
    this.onPressed,
    this.onLongPress,
    this.enabled = true,
    super.key,
  }) : onToggle = null,
       initialValue = null,
       activeSwitchColor = null,
       selected = false,
       sliderValue = null,
       sliderMin = 0.0,
       sliderMax = 1.0,
       sliderDivisions = null,
       onSliderChanged = null,
       sliderActiveColor = null,
       tileType = SettingsTileType.simpleTile;

  /// Creates a navigation tile that displays a trailing chevron indicator.
  const SettingsTile.navigation({
    this.leading,
    this.trailing,
    this.value,
    required this.title,
    this.description,
    this.onPressed,
    this.onLongPress,
    this.enabled = true,
    super.key,
  }) : onToggle = null,
       initialValue = null,
       activeSwitchColor = null,
       selected = false,
       sliderValue = null,
       sliderMin = 0.0,
       sliderMax = 1.0,
       sliderDivisions = null,
       onSliderChanged = null,
       sliderActiveColor = null,
       tileType = SettingsTileType.navigationTile;

  /// Creates a tile with an integrated platform-native toggle switch.
  const SettingsTile.switchTile({
    required this.initialValue,
    required this.onToggle,
    this.activeSwitchColor,
    this.leading,
    this.trailing,
    required this.title,
    this.description,
    this.onPressed,
    this.onLongPress,
    this.enabled = true,
    super.key,
  }) : value = null,
       selected = false,
       sliderValue = null,
       sliderMin = 0.0,
       sliderMax = 1.0,
       sliderDivisions = null,
       onSliderChanged = null,
       sliderActiveColor = null,
       tileType = SettingsTileType.switchTile;

  /// Creates a radio-style tile that shows a checkmark when [selected] is true.
  const SettingsTile.radioTile({
    required this.selected,
    this.leading,
    this.trailing,
    required this.title,
    this.description,
    this.onPressed,
    this.onLongPress,
    this.enabled = true,
    super.key,
  }) : onToggle = null,
       initialValue = null,
       activeSwitchColor = null,
       value = null,
       sliderValue = null,
       sliderMin = 0.0,
       sliderMax = 1.0,
       sliderDivisions = null,
       onSliderChanged = null,
       sliderActiveColor = null,
       tileType = SettingsTileType.simpleTile;

  /// Creates a tile with an inline slider control.
  ///
  /// The title is displayed at the start and the slider fills the remaining
  /// space. Optionally pass [value] to show a label (e.g. the current value)
  /// between the title and the slider.
  const SettingsTile.sliderTile({
    required this.sliderValue,
    required this.onSliderChanged,
    this.sliderMin = 0.0,
    this.sliderMax = 1.0,
    this.sliderDivisions,
    this.sliderActiveColor,
    this.leading,
    this.trailing,
    this.value,
    required this.title,
    this.description,
    this.onPressed,
    this.onLongPress,
    this.enabled = true,
    super.key,
  }) : onToggle = null,
       initialValue = null,
       activeSwitchColor = null,
       selected = false,
       tileType = SettingsTileType.sliderTile;

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

  /// A function that is called by long-press on a tile
  final Function(BuildContext context)? onLongPress;

  /// The color of the switch thumb/track when active.
  final Color? activeSwitchColor;

  /// An optional value widget shown between [title] and the trailing widget.
  final Widget? value;

  /// Callback invoked when the switch is toggled. Only used by [SettingsTile.switchTile].
  final Function(bool value)? onToggle;

  /// The visual type of this tile.
  final SettingsTileType tileType;

  /// The initial on/off state for [SettingsTile.switchTile].
  final bool? initialValue;

  /// Whether this tile is interactive. Disabled tiles are dimmed.
  final bool enabled;

  /// Whether this tile is the selected option in a radio group.
  final bool selected;

  /// Current slider value. Required for [SettingsTile.sliderTile].
  final double? sliderValue;

  /// Minimum slider value (defaults to 0.0).
  final double sliderMin;

  /// Maximum slider value (defaults to 1.0).
  final double sliderMax;

  /// Number of discrete divisions for the slider.
  final int? sliderDivisions;

  /// Called when the slider value changes.
  final ValueChanged<double>? onSliderChanged;

  /// Active track / thumb color for the slider.
  final Color? sliderActiveColor;

  @override
  Widget build(BuildContext context) {
    final theme = SettingsTheme.of(context);

    switch (theme.platform) {
      case DevicePlatform.android:
      case DevicePlatform.fuchsia:
      case DevicePlatform.linux:
      case DevicePlatform.windows:
      case DevicePlatform.web:
        return MaterialSettingsTile(
          description: description,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onToggle: onToggle,
          tileType: tileType,
          value: value,
          leading: leading,
          title: title,
          enabled: enabled,
          activeSwitchColor: activeSwitchColor,
          initialValue: initialValue ?? false,
          trailing: trailing,
          selected: selected,
          sliderValue: sliderValue,
          sliderMin: sliderMin,
          sliderMax: sliderMax,
          sliderDivisions: sliderDivisions,
          onSliderChanged: onSliderChanged,
          sliderActiveColor: sliderActiveColor,
        );
      case DevicePlatform.iOS:
      case DevicePlatform.macOS:
        return IOSSettingsTile(
          description: description,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onToggle: onToggle,
          tileType: tileType,
          value: value,
          leading: leading,
          title: title,
          trailing: trailing,
          enabled: enabled,
          activeSwitchColor: activeSwitchColor,
          initialValue: initialValue ?? false,
          selected: selected,
          sliderValue: sliderValue,
          sliderMin: sliderMin,
          sliderMax: sliderMax,
          sliderDivisions: sliderDivisions,
          onSliderChanged: onSliderChanged,
          sliderActiveColor: sliderActiveColor,
        );
    }
  }
}
