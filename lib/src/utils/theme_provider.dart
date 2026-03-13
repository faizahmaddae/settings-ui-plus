import 'package:flutter/cupertino.dart';
import 'package:settings_ui_plus/src/utils/platform_utils.dart';
import 'package:settings_ui_plus/src/utils/settings_theme.dart';

/// Default color palettes for each platform style.
abstract final class _AndroidColors {
  static const lightLeadingIcons = Color.fromARGB(255, 70, 70, 70);
  static const darkLeadingIcons = Color.fromARGB(255, 197, 197, 197);

  static const lightListBackground = Color.fromRGBO(240, 240, 240, 1);
  static const darkListBackground = Color.fromRGBO(27, 27, 27, 1);

  static const lightTitle = Color.fromRGBO(11, 87, 208, 1);
  static const darkTitle = Color.fromRGBO(211, 227, 253, 1);

  static const lightTileHighlight = Color.fromARGB(255, 220, 220, 220);
  static const darkTileHighlight = Color.fromARGB(255, 46, 46, 46);

  static const lightTileText = Color.fromARGB(255, 27, 27, 27);
  static const darkTileText = Color.fromARGB(255, 240, 240, 240);

  static const lightInactiveTitle = Color.fromARGB(255, 146, 144, 148);
  static const darkInactiveTitle = Color.fromARGB(255, 118, 117, 122);

  static const lightInactiveSubtitle = Color.fromARGB(255, 197, 196, 201);
  static const darkInactiveSubtitle = Color.fromARGB(255, 71, 70, 74);

  static const lightTileDescription = Color.fromARGB(255, 70, 70, 70);
  static const darkTileDescription = Color.fromARGB(255, 198, 198, 198);
}

abstract final class _IOSColors {
  static const lightListBackground = Color.fromRGBO(242, 242, 247, 1);
  static const darkListBackground = CupertinoColors.black;

  static const lightSectionBackground = CupertinoColors.white;
  static const darkSectionBackground = Color.fromARGB(255, 28, 28, 30);

  static const lightTitle = Color.fromRGBO(109, 109, 114, 1);
  static const darkTitle = Color.fromARGB(255, 152, 152, 159);

  static const lightDivider = Color.fromARGB(255, 198, 198, 200);
  static const darkDivider = Color.fromARGB(255, 40, 40, 42);

  static const lightTrailingText = Color.fromARGB(255, 110, 110, 115);
  static const darkTrailingText = Color.fromARGB(255, 152, 152, 159);

  static const lightTileHighlight = Color.fromARGB(255, 209, 209, 214);
  static const darkTileHighlight = Color.fromARGB(255, 58, 58, 60);

  static const lightTileText = CupertinoColors.black;
  static const darkTileText = CupertinoColors.white;

  static const leadingIcons = CupertinoColors.inactiveGray;
  static const inactive = CupertinoColors.inactiveGray;
}

abstract final class _WebColors {
  static const lightLeadingIcons = Color.fromARGB(255, 70, 70, 70);
  static const darkLeadingIcons = Color.fromARGB(255, 197, 197, 197);

  static const lightListBackground = Color.fromRGBO(240, 240, 240, 1);
  static const darkListBackground = Color.fromRGBO(32, 33, 36, 1);

  static const lightSectionBackground = CupertinoColors.white;
  static const darkSectionBackground = Color(0xFF292a2d);

  static const lightTitle = Color.fromRGBO(11, 87, 208, 1);
  static const darkTitle = Color.fromRGBO(232, 234, 237, 1);

  static const lightTileHighlight = Color.fromARGB(255, 220, 220, 220);
  static const darkTileHighlight = Color.fromARGB(255, 46, 46, 46);

  static const lightTileText = Color.fromARGB(255, 27, 27, 27);
  static const darkTileText = Color.fromARGB(232, 234, 237, 240);

  static const lightTileDescription = Color.fromARGB(255, 70, 70, 70);
  static const darkTileDescription = Color.fromARGB(154, 160, 166, 198);

  static const lightInactiveTitle = Color.fromARGB(255, 146, 144, 148);
  static const darkInactiveTitle = Color.fromARGB(255, 118, 117, 122);

  static const lightInactiveSubtitle = Color.fromARGB(255, 197, 196, 201);
  static const darkInactiveSubtitle = Color.fromARGB(255, 71, 70, 74);
}

class ThemeProvider {
  static final Map<(DevicePlatform, Brightness), SettingsThemeData> _cache = {};

  static SettingsThemeData getTheme({
    required DevicePlatform platform,
    required Brightness brightness,
  }) {
    return _cache.putIfAbsent(
      (platform, brightness),
      () => _buildTheme(platform, brightness),
    );
  }

  static SettingsThemeData _buildTheme(
    DevicePlatform platform,
    Brightness brightness,
  ) {
    switch (platform) {
      case DevicePlatform.android:
      case DevicePlatform.fuchsia:
      case DevicePlatform.linux:
      case DevicePlatform.windows:
        return _androidTheme(brightness);
      case DevicePlatform.iOS:
      case DevicePlatform.macOS:
        return _iosTheme(brightness);
      case DevicePlatform.web:
        return _webTheme(brightness);
    }
  }

  static SettingsThemeData _androidTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;

    return SettingsThemeData(
      settingsListBackground: isLight
          ? _AndroidColors.lightListBackground
          : _AndroidColors.darkListBackground,
      titleTextColor:
          isLight ? _AndroidColors.lightTitle : _AndroidColors.darkTitle,
      settingsTileTextColor:
          isLight ? _AndroidColors.lightTileText : _AndroidColors.darkTileText,
      tileHighlightColor: isLight
          ? _AndroidColors.lightTileHighlight
          : _AndroidColors.darkTileHighlight,
      tileDescriptionTextColor: isLight
          ? _AndroidColors.lightTileDescription
          : _AndroidColors.darkTileDescription,
      leadingIconsColor: isLight
          ? _AndroidColors.lightLeadingIcons
          : _AndroidColors.darkLeadingIcons,
      settingsSectionBackground: isLight
          ? const Color.fromARGB(255, 255, 255, 255)
          : const Color.fromARGB(255, 43, 43, 43),
      dividerColor: isLight
          ? const Color.fromARGB(255, 220, 220, 220)
          : const Color.fromARGB(255, 60, 60, 60),
      inactiveTitleColor: isLight
          ? _AndroidColors.lightInactiveTitle
          : _AndroidColors.darkInactiveTitle,
      inactiveSubtitleColor: isLight
          ? _AndroidColors.lightInactiveSubtitle
          : _AndroidColors.darkInactiveSubtitle,
    );
  }

  static SettingsThemeData _iosTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;

    return SettingsThemeData(
      settingsListBackground: isLight
          ? _IOSColors.lightListBackground
          : _IOSColors.darkListBackground,
      settingsSectionBackground: isLight
          ? _IOSColors.lightSectionBackground
          : _IOSColors.darkSectionBackground,
      titleTextColor:
          isLight ? _IOSColors.lightTitle : _IOSColors.darkTitle,
      settingsTileTextColor:
          isLight ? _IOSColors.lightTileText : _IOSColors.darkTileText,
      dividerColor:
          isLight ? _IOSColors.lightDivider : _IOSColors.darkDivider,
      trailingTextColor: isLight
          ? _IOSColors.lightTrailingText
          : _IOSColors.darkTrailingText,
      tileHighlightColor: isLight
          ? _IOSColors.lightTileHighlight
          : _IOSColors.darkTileHighlight,
      leadingIconsColor: _IOSColors.leadingIcons,
      tileDescriptionTextColor:
          isLight ? _IOSColors.lightTitle : _IOSColors.darkTitle,
      inactiveTitleColor: _IOSColors.inactive,
      inactiveSubtitleColor: _IOSColors.inactive,
    );
  }

  static SettingsThemeData _webTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;

    return SettingsThemeData(
      settingsListBackground: isLight
          ? _WebColors.lightListBackground
          : _WebColors.darkListBackground,
      settingsSectionBackground: isLight
          ? _WebColors.lightSectionBackground
          : _WebColors.darkSectionBackground,
      titleTextColor:
          isLight ? _WebColors.lightTitle : _WebColors.darkTitle,
      settingsTileTextColor:
          isLight ? _WebColors.lightTileText : _WebColors.darkTileText,
      tileHighlightColor: isLight
          ? _WebColors.lightTileHighlight
          : _WebColors.darkTileHighlight,
      tileDescriptionTextColor: isLight
          ? _WebColors.lightTileDescription
          : _WebColors.darkTileDescription,
      leadingIconsColor: isLight
          ? _WebColors.lightLeadingIcons
          : _WebColors.darkLeadingIcons,
      inactiveTitleColor: isLight
          ? _WebColors.lightInactiveTitle
          : _WebColors.darkInactiveTitle,
      inactiveSubtitleColor: isLight
          ? _WebColors.lightInactiveSubtitle
          : _WebColors.darkInactiveSubtitle,
    );
  }
}
