import 'package:flutter/material.dart';
import 'package:settings_ui_plus/settings_ui_plus.dart';
import 'package:settings_ui_plus/src/tiles/platforms/ios_settings_tile.dart';
import 'package:settings_ui_plus/src/utils/expandable_section_mixin.dart';

class IOSSettingsSection extends StatefulWidget {
  const IOSSettingsSection({
    required this.tiles,
    required this.margin,
    required this.title,
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
  State<IOSSettingsSection> createState() => _IOSSettingsSectionState();
}

class _IOSSettingsSectionState extends State<IOSSettingsSection>
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
    if (widget.tiles.isEmpty) return const SizedBox.shrink();

    final theme = SettingsTheme.of(context);
    final lastTile = widget.tiles.last;
    final isLastNonDescriptive =
        lastTile is SettingsTile && lastTile.description == null;
    final scaleFactor = MediaQuery.textScalerOf(context).scale(1);

    return Padding(
      padding:
          widget.margin ??
          EdgeInsetsDirectional.only(
            top: 14.0 * scaleFactor,
            bottom: isLastNonDescriptive ? 21 * scaleFactor : 10 * scaleFactor,
            start: 16,
            end: 16,
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            GestureDetector(
              onTap: widget.expandable ? toggleExpanded : null,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: 18,
                  bottom: 5 * scaleFactor,
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
                              fontSize: 13,
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
                          size: 18,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          SizeTransition(sizeFactor: expandAnimation, child: buildTileList()),
          if (widget.footer != null)
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: 18,
                top: 6 * scaleFactor,
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: theme.themeData.inactiveTitleColor,
                  fontSize: 13,
                  letterSpacing: -0.08,
                ),
                child: widget.footer!,
              ),
            ),
        ],
      ),
    );
  }

  Widget buildTileList() {
    final children = <Widget>[];
    for (var index = 0; index < widget.tiles.length; index++) {
      final tile = widget.tiles[index];

      var enableTop = false;

      if (index == 0 ||
          (index > 0 &&
              widget.tiles[index - 1] is SettingsTile &&
              (widget.tiles[index - 1] as SettingsTile).description != null)) {
        enableTop = true;
      }

      var enableBottom = false;

      if (index == widget.tiles.length - 1 ||
          (index < widget.tiles.length &&
              tile is SettingsTile &&
              (tile).description != null)) {
        enableBottom = true;
      }

      children.add(
        IOSSettingsTileAdditionalInfo(
          enableTopBorderRadius: enableTop,
          enableBottomBorderRadius: enableBottom,
          needToShowDivider: index != widget.tiles.length - 1,
          child: tile,
        ),
      );
    }
    return Column(mainAxisSize: MainAxisSize.min, children: children);
  }
}
