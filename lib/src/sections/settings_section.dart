import 'package:flutter/material.dart';
import 'package:settings_ui_plus/src/sections/abstract_settings_section.dart';
import 'package:settings_ui_plus/src/sections/platforms/ios_settings_section.dart';
import 'package:settings_ui_plus/src/sections/platforms/material_settings_section.dart';
import 'package:settings_ui_plus/src/tiles/abstract_settings_tile.dart';
import 'package:settings_ui_plus/src/utils/platform_utils.dart';
import 'package:settings_ui_plus/src/utils/settings_theme.dart';

/// A group of related [SettingsTile]s displayed under an optional [title].
///
/// Set [expandable] to `true` to allow the section to be collapsed/expanded
/// by tapping its title. Use [initiallyExpanded] to control the starting state.
class SettingsSection extends AbstractSettingsSection {
  const SettingsSection({
    required this.tiles,
    this.margin,
    this.title,
    this.footer,
    this.expandable = false,
    this.initiallyExpanded = true,
    super.key,
  });

  final List<AbstractSettingsTile> tiles;
  final EdgeInsetsDirectional? margin;
  final Widget? title;

  /// Optional footer widget displayed below the section tiles.
  ///
  /// Typically used for help text or disclaimers.
  final Widget? footer;

  /// Whether this section can be collapsed/expanded by tapping its title.
  final bool expandable;

  /// If [expandable] is true, whether the section starts expanded.
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = SettingsTheme.of(context);

    switch (theme.platform) {
      case DevicePlatform.android:
      case DevicePlatform.fuchsia:
      case DevicePlatform.linux:
      case DevicePlatform.windows:
      case DevicePlatform.web:
        return MaterialSettingsSection(
          title: title,
          tiles: tiles,
          margin: margin,
          footer: footer,
          expandable: expandable,
          initiallyExpanded: initiallyExpanded,
        );
      case DevicePlatform.iOS:
      case DevicePlatform.macOS:
        return IOSSettingsSection(
          title: title,
          tiles: tiles,
          margin: margin,
          footer: footer,
          expandable: expandable,
          initiallyExpanded: initiallyExpanded,
        );
    }
  }
}
