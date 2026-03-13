import 'package:flutter/material.dart';
import 'package:settings_ui_plus/src/utils/platform_utils.dart';

/// An [InheritedWidget] that propagates [SettingsThemeData] and the active
/// [DevicePlatform] down the widget tree.
///
/// This is inserted automatically by [SettingsList]; you typically don't need
/// to use it directly. Access it via [SettingsTheme.of].
class SettingsTheme extends InheritedWidget {
  /// The theme data for settings widgets.
  final SettingsThemeData themeData;

  /// The active platform that controls widget rendering.
  final DevicePlatform platform;

  const SettingsTheme({
    required this.themeData,
    required this.platform,
    required super.child,
    super.key,
  });

  @override
  bool updateShouldNotify(SettingsTheme old) =>
      themeData != old.themeData || platform != old.platform;

  static SettingsTheme of(BuildContext context) {
    final SettingsTheme? result =
        context.dependOnInheritedWidgetOfExactType<SettingsTheme>();
    assert(result != null, 'No SettingsTheme found. Wrap your widget tree with a SettingsList.');
    return result!;
  }
}

/// Color and text-style overrides for settings widgets.
///
/// Pass a [SettingsThemeData] to [SettingsList.lightTheme] or
/// [SettingsList.darkTheme] to customise the look of all sections and tiles.
class SettingsThemeData {
  const SettingsThemeData({
    this.trailingTextColor,
    this.settingsListBackground,
    this.settingsSectionBackground,
    this.dividerColor,
    this.tileHighlightColor,
    this.titleTextColor,
    this.leadingIconsColor,
    this.tileDescriptionTextColor,
    this.settingsTileTextColor,
    this.inactiveTitleColor,
    this.inactiveSubtitleColor,
    this.titleTextStyle,
    this.descriptionTextStyle,
    this.sectionTitleTextStyle,
  });

  final Color? settingsListBackground;
  final Color? trailingTextColor;
  final Color? leadingIconsColor;
  final Color? settingsSectionBackground;
  final Color? dividerColor;
  final Color? tileDescriptionTextColor;
  final Color? tileHighlightColor;
  final Color? titleTextColor;
  final Color? settingsTileTextColor;
  final Color? inactiveTitleColor;
  final Color? inactiveSubtitleColor;

  /// Custom text style for tile titles. Overrides the default platform style.
  final TextStyle? titleTextStyle;

  /// Custom text style for tile descriptions. Overrides the default platform style.
  final TextStyle? descriptionTextStyle;

  /// Custom text style for section titles. Overrides the default platform style.
  final TextStyle? sectionTitleTextStyle;

  SettingsThemeData merge({
    SettingsThemeData? theme,
  }) {
    if (theme == null) return this;

    return copyWith(
      leadingIconsColor: theme.leadingIconsColor,
      tileDescriptionTextColor: theme.tileDescriptionTextColor,
      dividerColor: theme.dividerColor,
      trailingTextColor: theme.trailingTextColor,
      settingsListBackground: theme.settingsListBackground,
      settingsSectionBackground: theme.settingsSectionBackground,
      settingsTileTextColor: theme.settingsTileTextColor,
      tileHighlightColor: theme.tileHighlightColor,
      titleTextColor: theme.titleTextColor,
      inactiveTitleColor: theme.inactiveTitleColor,
      inactiveSubtitleColor: theme.inactiveSubtitleColor,
      titleTextStyle: theme.titleTextStyle,
      descriptionTextStyle: theme.descriptionTextStyle,
      sectionTitleTextStyle: theme.sectionTitleTextStyle,
    );
  }

  SettingsThemeData copyWith({
    Color? settingsListBackground,
    Color? trailingTextColor,
    Color? leadingIconsColor,
    Color? settingsSectionBackground,
    Color? dividerColor,
    Color? tileDescriptionTextColor,
    Color? tileHighlightColor,
    Color? titleTextColor,
    Color? settingsTileTextColor,
    Color? inactiveTitleColor,
    Color? inactiveSubtitleColor,
    TextStyle? titleTextStyle,
    TextStyle? descriptionTextStyle,
    TextStyle? sectionTitleTextStyle,
  }) {
    return SettingsThemeData(
      settingsListBackground:
          settingsListBackground ?? this.settingsListBackground,
      trailingTextColor: trailingTextColor ?? this.trailingTextColor,
      leadingIconsColor: leadingIconsColor ?? this.leadingIconsColor,
      settingsSectionBackground:
          settingsSectionBackground ?? this.settingsSectionBackground,
      dividerColor: dividerColor ?? this.dividerColor,
      tileDescriptionTextColor:
          tileDescriptionTextColor ?? this.tileDescriptionTextColor,
      tileHighlightColor: tileHighlightColor ?? this.tileHighlightColor,
      titleTextColor: titleTextColor ?? this.titleTextColor,
      inactiveTitleColor: inactiveTitleColor ?? this.inactiveTitleColor,
      inactiveSubtitleColor:
          inactiveSubtitleColor ?? this.inactiveSubtitleColor,
      settingsTileTextColor:
          settingsTileTextColor ?? this.settingsTileTextColor,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      descriptionTextStyle: descriptionTextStyle ?? this.descriptionTextStyle,
      sectionTitleTextStyle:
          sectionTitleTextStyle ?? this.sectionTitleTextStyle,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsThemeData &&
          settingsListBackground == other.settingsListBackground &&
          trailingTextColor == other.trailingTextColor &&
          leadingIconsColor == other.leadingIconsColor &&
          settingsSectionBackground == other.settingsSectionBackground &&
          dividerColor == other.dividerColor &&
          tileDescriptionTextColor == other.tileDescriptionTextColor &&
          tileHighlightColor == other.tileHighlightColor &&
          titleTextColor == other.titleTextColor &&
          settingsTileTextColor == other.settingsTileTextColor &&
          inactiveTitleColor == other.inactiveTitleColor &&
          inactiveSubtitleColor == other.inactiveSubtitleColor &&
          titleTextStyle == other.titleTextStyle &&
          descriptionTextStyle == other.descriptionTextStyle &&
          sectionTitleTextStyle == other.sectionTitleTextStyle;

  @override
  int get hashCode => Object.hash(
        settingsListBackground,
        trailingTextColor,
        leadingIconsColor,
        settingsSectionBackground,
        dividerColor,
        tileDescriptionTextColor,
        tileHighlightColor,
        titleTextColor,
        settingsTileTextColor,
        inactiveTitleColor,
        inactiveSubtitleColor,
        titleTextStyle,
        descriptionTextStyle,
        sectionTitleTextStyle,
      );
}
