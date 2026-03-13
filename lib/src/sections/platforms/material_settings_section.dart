import 'package:flutter/material.dart';
import 'package:settings_ui_plus/src/tiles/abstract_settings_tile.dart';
import 'package:settings_ui_plus/src/utils/expandable_section_mixin.dart';
import 'package:settings_ui_plus/src/utils/platform_utils.dart';
import 'package:settings_ui_plus/src/utils/settings_theme.dart';

class MaterialSettingsSection extends StatefulWidget {
  const MaterialSettingsSection({
    required this.tiles,
    required this.margin,
    this.title,
    this.footer,
    this.expandable = false,
    this.initiallyExpanded = true,
    super.key,
  });

  final List<AbstractSettingsTile> tiles;
  final EdgeInsetsDirectional? margin;
  final Widget? title;
  final Widget? footer;
  final bool expandable;
  final bool initiallyExpanded;

  @override
  State<MaterialSettingsSection> createState() =>
      _MaterialSettingsSectionState();
}

class _MaterialSettingsSectionState extends State<MaterialSettingsSection>
    with SingleTickerProviderStateMixin, ExpandableSectionMixin {
  @override
  void initState() {
    super.initState();
    initExpandable(initiallyExpanded: widget.initiallyExpanded);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    expandController.duration = disableAnimations
        ? Duration.zero
        : const Duration(milliseconds: 200);
  }

  @override
  void dispose() {
    disposeExpandable();
    super.dispose();
  }

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

    if (widget.tiles.isEmpty && widget.title == null && widget.footer == null) {
      return const SizedBox.shrink();
    }

    if (widget.title == null && widget.footer == null) {
      return tileList;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          GestureDetector(
            onTap: widget.expandable ? toggleExpanded : null,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                top: 24 * scaleFactor,
                bottom: 10 * scaleFactor,
                start: 24,
                end: 24,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: DefaultTextStyle(
                      style:
                          theme.themeData.sectionTitleTextStyle?.copyWith(
                            color: theme.themeData.titleTextColor,
                          ) ??
                          TextStyle(color: theme.themeData.titleTextColor),
                      child: widget.title!,
                    ),
                  ),
                  if (widget.expandable)
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.expand_more,
                        color: theme.themeData.titleTextColor,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),
          ),
        SizeTransition(
          sizeFactor: expandAnimation,
          child: Container(
            color: theme.themeData.settingsSectionBackground,
            child: tileList,
          ),
        ),
        if (widget.footer != null)
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: 24,
              end: 24,
              top: 8 * scaleFactor,
            ),
            child: DefaultTextStyle(
              style: TextStyle(
                color: theme.themeData.tileDescriptionTextColor,
                fontSize: 12,
              ),
              child: widget.footer!,
            ),
          ),
      ],
    );
  }

  Widget _buildWebLayout(BuildContext context) {
    final theme = SettingsTheme.of(context);
    final scaleFactor = MediaQuery.textScalerOf(context).scale(1);

    return Padding(
      padding: widget.margin ?? EdgeInsetsDirectional.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            GestureDetector(
              onTap: widget.expandable ? toggleExpanded : null,
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 65 * scaleFactor,
                padding: EdgeInsetsDirectional.only(
                  bottom: 5 * scaleFactor,
                  start: 6,
                  end: 6,
                  top: 40 * scaleFactor,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextStyle(
                        style:
                            theme.themeData.sectionTitleTextStyle?.copyWith(
                              color: theme.themeData.titleTextColor,
                            ) ??
                            TextStyle(
                              color: theme.themeData.titleTextColor,
                              fontSize: 15,
                            ),
                        child: widget.title!,
                      ),
                    ),
                    if (widget.expandable)
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.expand_more,
                          color: theme.themeData.titleTextColor,
                          size: 20,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          SizeTransition(
            sizeFactor: expandAnimation,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              color: theme.themeData.settingsSectionBackground,
              child: _buildTileList(showSeparators: true),
            ),
          ),
          if (widget.footer != null)
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: 6,
                top: 8 * scaleFactor,
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: theme.themeData.tileDescriptionTextColor,
                  fontSize: 12,
                ),
                child: widget.footer!,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTileList({required bool showSeparators}) {
    if (showSeparators) {
      return ListView.separated(
        shrinkWrap: true,
        itemCount: widget.tiles.length,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return widget.tiles[index];
        },
        separatorBuilder: (BuildContext context, int index) {
          final theme = SettingsTheme.of(context);
          return Divider(
            height: 1.0,
            thickness: 1.0,
            color: theme.themeData.dividerColor,
          );
        },
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.tiles.length,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return widget.tiles[index];
      },
    );
  }
}
