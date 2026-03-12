import 'package:flutter/material.dart';
import 'package:settings_ui_plus/src/tiles/abstract_settings_tile.dart';
import 'package:settings_ui_plus/src/utils/platform_utils.dart';
import 'package:settings_ui_plus/src/utils/settings_theme.dart';

class MaterialSettingsSection extends StatelessWidget {
  const MaterialSettingsSection({
    required this.tiles,
    required this.margin,
    this.title,
    super.key,
  });

  final List<AbstractSettingsTile> tiles;
  final EdgeInsetsDirectional? margin;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    final platform = SettingsTheme.of(context).platform;

    if (platform == DevicePlatform.web) {
      return _buildWebLayout(context);
    }
    return _buildAndroidLayout(context);
  }

  Widget _buildAndroidLayout(BuildContext context) {
    final theme = SettingsTheme.of(context);
    final scaleFactor = MediaQuery.textScalerOf(context).scale(1);
    final tileList = _buildTileList(showSeparators: false);

    if (title == null) {
      return tileList;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(
            top: 24 * scaleFactor,
            bottom: 10 * scaleFactor,
            start: 24,
            end: 24,
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              color: theme.themeData.titleTextColor,
            ),
            child: title!,
          ),
        ),
        Container(
          color: theme.themeData.settingsSectionBackground,
          child: tileList,
        ),
      ],
    );
  }

  Widget _buildWebLayout(BuildContext context) {
    final theme = SettingsTheme.of(context);
    final scaleFactor = MediaQuery.textScalerOf(context).scale(1);

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Container(
              height: 65 * scaleFactor,
              padding: EdgeInsetsDirectional.only(
                bottom: 5 * scaleFactor,
                start: 6,
                top: 40 * scaleFactor,
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: theme.themeData.titleTextColor,
                  fontSize: 15,
                ),
                child: title!,
              ),
            ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 4,
            color: theme.themeData.settingsSectionBackground,
            child: _buildTileList(showSeparators: true),
          ),
        ],
      ),
    );
  }

  Widget _buildTileList({required bool showSeparators}) {
    if (showSeparators) {
      return ListView.separated(
        shrinkWrap: true,
        itemCount: tiles.length,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return tiles[index];
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 0,
            thickness: 1,
          );
        },
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: tiles.length,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return tiles[index];
      },
    );
  }
}
