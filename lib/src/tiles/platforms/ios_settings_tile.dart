import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui_plus/settings_ui_plus.dart';

class IOSSettingsTile extends StatefulWidget {
  const IOSSettingsTile({
    required this.tileType,
    required this.leading,
    required this.title,
    required this.description,
    required this.onPressed,
    required this.onLongPress,
    required this.onToggle,
    required this.value,
    required this.initialValue,
    required this.activeSwitchColor,
    required this.enabled,
    required this.trailing,
    this.selected = false,
    this.sliderValue,
    this.sliderMin = 0.0,
    this.sliderMax = 1.0,
    this.sliderDivisions,
    this.onSliderChanged,
    this.sliderActiveColor,
    super.key,
  });

  final SettingsTileType tileType;
  final Widget? leading;
  final Widget? title;
  final Widget? description;
  final Function(BuildContext context)? onPressed;
  final Function(BuildContext context)? onLongPress;
  final Function(bool value)? onToggle;
  final Widget? value;
  final bool? initialValue;
  final bool enabled;
  final Color? activeSwitchColor;
  final Widget? trailing;
  final bool selected;
  final double? sliderValue;
  final double sliderMin;
  final double sliderMax;
  final int? sliderDivisions;
  final ValueChanged<double>? onSliderChanged;
  final Color? sliderActiveColor;

  @override
  State<IOSSettingsTile> createState() => _IOSSettingsTileState();
}

class _IOSSettingsTileState extends State<IOSSettingsTile> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final additionalInfo = IOSSettingsTileAdditionalInfo.of(context);
    final theme = SettingsTheme.of(context);

    return Semantics(
      enabled: widget.enabled,
      toggled:
          widget.tileType == SettingsTileType.switchTile
              ? widget.initialValue
              : null,
      button: widget.tileType != SettingsTileType.switchTile,
      hint: widget.tileType == SettingsTileType.switchTile
          ? (widget.onToggle != null ? 'Double-tap to toggle' : null)
          : widget.tileType == SettingsTileType.sliderTile
              ? (widget.onSliderChanged != null || widget.onPressed != null
                  ? 'Adjust with slider'
                  : null)
              : (widget.onPressed != null ? 'Double-tap to activate' : null),
      child: Opacity(
        opacity: widget.enabled ? 1.0 : 0.5,
        child: IgnorePointer(
          ignoring: !widget.enabled,
          child: Column(
          children: [
            buildTitle(
              context: context,
              theme: theme,
              additionalInfo: additionalInfo,
            ),
            if (widget.description != null)
              buildDescription(
                context: context,
                theme: theme,
                additionalInfo: additionalInfo,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitle({
    required BuildContext context,
    required SettingsTheme theme,
    required IOSSettingsTileAdditionalInfo additionalInfo,
  }) {
    Widget content = buildTileContent(context, theme, additionalInfo);
    if (theme.platform != DevicePlatform.iOS) {
      content = Material(
        color: Colors.transparent,
        child: content,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: additionalInfo.enableTopBorderRadius
            ? const Radius.circular(12)
            : Radius.zero,
        bottom: additionalInfo.enableBottomBorderRadius
            ? const Radius.circular(12)
            : Radius.zero,
      ),
      child: content,
    );
  }

  Widget buildDescription({
    required BuildContext context,
    required SettingsTheme theme,
    required IOSSettingsTileAdditionalInfo additionalInfo,
  }) {
    final scaleFactor = MediaQuery.textScalerOf(context).scale(1);

    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsetsDirectional.only(
        start: 18,
        end: 18,
        top: 8 * scaleFactor,
        bottom: additionalInfo.needToShowDivider ? 24 : 8 * scaleFactor,
      ),
      decoration: BoxDecoration(
        color: theme.themeData.settingsListBackground,
      ),
      child: DefaultTextStyle(
        style: theme.themeData.descriptionTextStyle?.copyWith(
              color: widget.enabled
                  ? theme.themeData.tileDescriptionTextColor
                  : theme.themeData.inactiveTitleColor,
            ) ??
            TextStyle(
              color: widget.enabled
                  ? theme.themeData.tileDescriptionTextColor
                  : theme.themeData.inactiveTitleColor,
              fontSize: 13,
            ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        child: widget.description!,
      ),
    );
  }

  Widget buildTrailing({
    required BuildContext context,
    required SettingsTheme theme,
  }) {
    final scaleFactor = MediaQuery.textScalerOf(context).scale(1);

    return Row(
      children: [
        if (widget.trailing != null) widget.trailing!,
        if (widget.tileType == SettingsTileType.switchTile)
          CupertinoSwitch(
            value: widget.initialValue ?? false,
            onChanged: widget.onToggle,
            activeTrackColor: widget.enabled
                ? widget.activeSwitchColor
                : null,
          ),
        if ((widget.tileType == SettingsTileType.navigationTile ||
                widget.tileType == SettingsTileType.sliderTile) &&
            widget.value != null)
          DefaultTextStyle(
            style: TextStyle(
              color: widget.enabled
                  ? theme.themeData.trailingTextColor
                  : theme.themeData.inactiveTitleColor,
              fontSize: 17,
            ),
            child: widget.value!,
          ),
        if (widget.tileType == SettingsTileType.navigationTile)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 6, end: 2),
            child: IconTheme(
              data: IconTheme.of(context)
                  .copyWith(color: theme.themeData.leadingIconsColor),
              child: Icon(
                CupertinoIcons.chevron_forward,
                size: 14 * scaleFactor,
              ),
            ),
          ),
        if (widget.selected && widget.trailing == null)
          Icon(
            CupertinoIcons.checkmark_alt,
            color: CupertinoColors.systemBlue,
            size: 20 * scaleFactor,
          ),
      ],
    );
  }

  void changePressState({bool isPressed = false}) {
    if (mounted) {
      setState(() {
        this.isPressed = isPressed;
      });
    }
  }

  Widget buildTileContent(
    BuildContext context,
    SettingsTheme theme,
    IOSSettingsTileAdditionalInfo additionalInfo,
  ) {
    if (widget.tileType == SettingsTileType.sliderTile) {
      return _buildSliderTileContent(context, theme, additionalInfo);
    }
    return _buildStandardTileContent(context, theme, additionalInfo);
  }

  Widget _buildSliderTileContent(
    BuildContext context,
    SettingsTheme theme,
    IOSSettingsTileAdditionalInfo additionalInfo,
  ) {
    final scaleFactor = MediaQuery.textScalerOf(context).scale(1);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onPressed == null
          ? null
          : () {
              changePressState(isPressed: false);
              widget.onPressed!.call(context);
            },
      onLongPress: widget.onLongPress == null
          ? null
          : () {
              changePressState(isPressed: false);
              widget.onLongPress!.call(context);
            },
      onTapDown: (_) =>
          widget.onPressed == null ? null : changePressState(isPressed: true),
      onTapUp: (_) =>
          widget.onPressed == null ? null : changePressState(isPressed: false),
      onTapCancel: () =>
          widget.onPressed == null ? null : changePressState(isPressed: false),
      child: Opacity(
        opacity: isPressed ? 0.7 : 1.0,
        child: Container(
          color: theme.themeData.settingsSectionBackground,
          padding: EdgeInsetsDirectional.only(
            start: 16,
            top: 10 * scaleFactor,
            bottom: 4 * scaleFactor,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Leading icon, vertically centered
              if (widget.leading != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 14.0),
                  child: IconTheme.merge(
                    data: IconThemeData(
                      color: widget.enabled
                          ? theme.themeData.leadingIconsColor
                          : theme.themeData.inactiveTitleColor,
                    ),
                    child: widget.leading!,
                  ),
                ),
              // Content column: title row + description + slider
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row: title ... value
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: DefaultTextStyle(
                              style: theme.themeData.titleTextStyle?.copyWith(
                                    color: widget.enabled
                                        ? theme.themeData.settingsTileTextColor
                                        : theme.themeData.inactiveTitleColor,
                                  ) ??
                                  TextStyle(
                                    color: widget.enabled
                                        ? theme.themeData.settingsTileTextColor
                                        : theme.themeData.inactiveTitleColor,
                                    fontSize: 17,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              child: widget.title ?? const SizedBox.shrink(),
                            ),
                          ),
                          if (widget.value != null)
                            Padding(
                              padding: const EdgeInsetsDirectional.only(start: 8),
                              child: DefaultTextStyle(
                                style: TextStyle(
                                  color: widget.enabled
                                      ? theme.themeData.trailingTextColor
                                      : theme.themeData.inactiveTitleColor,
                                  fontSize: 17,
                                ),
                                child: widget.value!,
                              ),
                            ),
                          if (widget.trailing != null)
                            Padding(
                              padding: const EdgeInsetsDirectional.only(start: 8),
                              child: widget.trailing!,
                            ),
                        ],
                      ),
                    ),
                    // Description below title if present
                    if (widget.description != null)
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                          end: 16,
                          top: 2 * scaleFactor,
                        ),
                        child: DefaultTextStyle(
                          style: theme.themeData.descriptionTextStyle?.copyWith(
                                color: widget.enabled
                                    ? theme.themeData.tileDescriptionTextColor
                                    : theme.themeData.inactiveTitleColor,
                              ) ??
                              TextStyle(
                                color: widget.enabled
                                    ? theme.themeData.tileDescriptionTextColor
                                    : theme.themeData.inactiveTitleColor,
                                fontSize: 13,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          child: widget.description!,
                        ),
                      ),
                    // Slider filling the full content width
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        end: 16,
                        top: 2 * scaleFactor,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: CupertinoSlider(
                          value: widget.sliderValue ?? widget.sliderMin,
                          min: widget.sliderMin,
                          max: widget.sliderMax,
                          divisions: widget.sliderDivisions,
                          onChanged:
                              widget.enabled ? widget.onSliderChanged : null,
                          activeColor: widget.sliderActiveColor,
                        ),
                      ),
                    ),
                    if (widget.description == null &&
                        additionalInfo.needToShowDivider)
                      Divider(
                        height: 0,
                        thickness: 0.5,
                        color: theme.themeData.dividerColor,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStandardTileContent(
    BuildContext context,
    SettingsTheme theme,
    IOSSettingsTileAdditionalInfo additionalInfo,
  ) {
    final scaleFactor = MediaQuery.textScalerOf(context).scale(1);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onPressed == null
          ? null
          : () {
              changePressState(isPressed: false);
              widget.onPressed!.call(context);
            },
      onLongPress: widget.onLongPress == null
          ? null
          : () {
              changePressState(isPressed: false);
              widget.onLongPress!.call(context);
            },
      onTapDown: (_) =>
          widget.onPressed == null ? null : changePressState(isPressed: true),
      onTapUp: (_) =>
          widget.onPressed == null ? null : changePressState(isPressed: false),
      onTapCancel: () =>
          widget.onPressed == null ? null : changePressState(isPressed: false),
      child: Opacity(
        opacity: isPressed ? 0.7 : 1.0,
        child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        color: theme.themeData.settingsSectionBackground,
        padding: const EdgeInsetsDirectional.only(start: 16),
        child: Row(
          children: [
            if (widget.leading != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 14.0),
                child: IconTheme.merge(
                  data: IconThemeData(
                    color: widget.enabled
                        ? theme.themeData.leadingIconsColor
                        : theme.themeData.inactiveTitleColor,
                  ),
                  child: widget.leading!,
                ),
              ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                              top: 12 * scaleFactor,
                              bottom: 12 * scaleFactor,
                            ),
                            child: DefaultTextStyle(
                              style: theme.themeData.titleTextStyle?.copyWith(
                                    color: widget.enabled
                                        ? theme.themeData.settingsTileTextColor
                                        : theme.themeData.inactiveTitleColor,
                                  ) ??
                                  TextStyle(
                                    color: widget.enabled
                                        ? theme.themeData.settingsTileTextColor
                                        : theme.themeData.inactiveTitleColor,
                                    fontSize: 17,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              child: widget.title ?? const SizedBox.shrink(),
                            ),
                          ),
                        ),
                        buildTrailing(context: context, theme: theme),
                      ],
                    ),
                  ),
                  if (widget.description == null &&
                      additionalInfo.needToShowDivider)
                    Divider(
                      height: 0,
                      thickness: 0.5,
                      color: theme.themeData.dividerColor,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class IOSSettingsTileAdditionalInfo extends InheritedWidget {
  final bool needToShowDivider;
  final bool enableTopBorderRadius;
  final bool enableBottomBorderRadius;

  const IOSSettingsTileAdditionalInfo({
    required this.needToShowDivider,
    required this.enableTopBorderRadius,
    required this.enableBottomBorderRadius,
    required super.child,
    super.key,
  });

  @override
  bool updateShouldNotify(IOSSettingsTileAdditionalInfo old) =>
      needToShowDivider != old.needToShowDivider ||
      enableTopBorderRadius != old.enableTopBorderRadius ||
      enableBottomBorderRadius != old.enableBottomBorderRadius;

  static IOSSettingsTileAdditionalInfo of(BuildContext context) {
    final IOSSettingsTileAdditionalInfo? result = context
        .dependOnInheritedWidgetOfExactType<IOSSettingsTileAdditionalInfo>();
    assert(result != null,
        'IOSSettingsTileAdditionalInfo not found. Ensure the tile is placed within an IOSSettingsSection.');
    return result!;
  }
}
