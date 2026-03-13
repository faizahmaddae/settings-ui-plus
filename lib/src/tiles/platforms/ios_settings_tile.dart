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
    this.dropdownItems,
    this.dropdownValue,
    this.onDropdownChanged,
    this.tileTheme,
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
  final List<DropdownSettingsItem>? dropdownItems;
  final String? dropdownValue;
  final ValueChanged<String?>? onDropdownChanged;
  final SettingsTileThemeData? tileTheme;

  @override
  State<IOSSettingsTile> createState() => _IOSSettingsTileState();
}

class _IOSSettingsTileState extends State<IOSSettingsTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _pressAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
      value: 1.0,
      lowerBound: 0.7,
      upperBound: 1.0,
    );
    _pressAnimation = _pressController;
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final additionalInfo = IOSSettingsTileAdditionalInfo.of(context);
    final theme = SettingsTheme.of(context);

    return Semantics(
      enabled: widget.enabled,
      toggled: widget.tileType == SettingsTileType.switchTile
          ? widget.initialValue
          : null,
      selected: widget.tileType == SettingsTileType.radioTile
          ? widget.selected
          : null,
      inMutuallyExclusiveGroup: widget.tileType == SettingsTileType.radioTile
          ? true
          : null,
      button:
          widget.tileType != SettingsTileType.switchTile &&
          widget.tileType != SettingsTileType.radioTile,
      hint: widget.tileType == SettingsTileType.switchTile
          ? (widget.onToggle != null ? 'Double-tap to toggle' : null)
          : widget.tileType == SettingsTileType.sliderTile
          ? (widget.onSliderChanged != null || widget.onPressed != null
                ? 'Adjust with slider'
                : null)
          : widget.tileType == SettingsTileType.dropdownTile
          ? (widget.onDropdownChanged != null ? 'Double-tap to select' : null)
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
      content = Material(color: Colors.transparent, child: content);
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
      decoration: BoxDecoration(color: theme.themeData.settingsListBackground),
      child: DefaultTextStyle(
        style:
            widget.tileTheme?.descriptionTextStyle ??
            theme.themeData.descriptionTextStyle?.copyWith(
              color:
                  widget.tileTheme?.descriptionColor ??
                  (widget.enabled
                      ? theme.themeData.tileDescriptionTextColor
                      : theme.themeData.inactiveTitleColor),
            ) ??
            TextStyle(
              color:
                  widget.tileTheme?.descriptionColor ??
                  (widget.enabled
                      ? theme.themeData.tileDescriptionTextColor
                      : theme.themeData.inactiveTitleColor),
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
            activeTrackColor: widget.enabled ? widget.activeSwitchColor : null,
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
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: widget.value!,
            ),
          ),
        if (widget.tileType == SettingsTileType.dropdownTile &&
            widget.dropdownItems != null)
          GestureDetector(
            onTap: widget.onDropdownChanged == null
                ? null
                : () => _showDropdownSheet(context, theme),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DefaultTextStyle(
                  style: TextStyle(
                    color: widget.enabled
                        ? theme.themeData.trailingTextColor
                        : theme.themeData.inactiveTitleColor,
                    fontSize: 17,
                  ),
                  child: _selectedDropdownLabel ?? const SizedBox.shrink(),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 6, end: 2),
                  child: Icon(
                    CupertinoIcons.chevron_up_chevron_down,
                    size: 14 * scaleFactor,
                    color: theme.themeData.leadingIconsColor,
                  ),
                ),
              ],
            ),
          ),
        if (widget.tileType == SettingsTileType.navigationTile)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 6, end: 2),
            child: IconTheme(
              data: IconTheme.of(
                context,
              ).copyWith(color: theme.themeData.leadingIconsColor),
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

  Widget? get _selectedDropdownLabel {
    if (widget.dropdownValue == null || widget.dropdownItems == null) {
      return null;
    }
    for (final item in widget.dropdownItems!) {
      if (item.value == widget.dropdownValue) {
        return item.child;
      }
    }
    return null;
  }

  void _showDropdownSheet(BuildContext context, SettingsTheme theme) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        actions: widget.dropdownItems!.map((item) {
          return CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(sheetContext).pop(item.value);
            },
            isDefaultAction: item.value == widget.dropdownValue,
            child: item.child,
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.of(sheetContext).pop(),
          child: const Text('Cancel'),
        ),
      ),
    ).then((selectedValue) {
      if (selectedValue != null) {
        widget.onDropdownChanged?.call(selectedValue);
      }
    });
  }

  void changePressState({bool isPressed = false}) {
    if (mounted) {
      if (isPressed) {
        _pressController.reverse();
      } else {
        _pressController.forward();
      }
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
    final effectiveTitleColor =
        widget.tileTheme?.titleColor ??
        (widget.enabled
            ? theme.themeData.settingsTileTextColor
            : theme.themeData.inactiveTitleColor);
    final effectiveDescriptionColor =
        widget.tileTheme?.descriptionColor ??
        (widget.enabled
            ? theme.themeData.tileDescriptionTextColor
            : theme.themeData.inactiveTitleColor);
    final effectiveTitleStyle =
        widget.tileTheme?.titleTextStyle ??
        theme.themeData.titleTextStyle?.copyWith(color: effectiveTitleColor) ??
        TextStyle(color: effectiveTitleColor, fontSize: 17);
    final effectiveDescriptionStyle =
        widget.tileTheme?.descriptionTextStyle ??
        theme.themeData.descriptionTextStyle?.copyWith(
          color: effectiveDescriptionColor,
        ) ??
        TextStyle(color: effectiveDescriptionColor, fontSize: 13);
    final effectiveBg =
        widget.tileTheme?.backgroundColor ??
        theme.themeData.settingsSectionBackground;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title area with gesture handling (same structure as standard tile)
        GestureDetector(
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
          onTapDown: (_) => widget.onPressed == null
              ? null
              : changePressState(isPressed: true),
          onTapUp: (_) => widget.onPressed == null
              ? null
              : changePressState(isPressed: false),
          onTapCancel: () => widget.onPressed == null
              ? null
              : changePressState(isPressed: false),
          child: FadeTransition(
            opacity: _pressAnimation,
            child: Container(
              color: effectiveBg,
              padding: const EdgeInsetsDirectional.only(start: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.leading != null)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 14.0),
                      child: IconTheme.merge(
                        data: IconThemeData(
                          color:
                              widget.tileTheme?.leadingIconColor ??
                              (widget.enabled
                                  ? theme.themeData.leadingIconsColor
                                  : theme.themeData.inactiveTitleColor),
                        ),
                        child: widget.leading!,
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                        end: 16,
                        top: 12 * scaleFactor,
                        bottom: 4 * scaleFactor,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: DefaultTextStyle(
                                  style: effectiveTitleStyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  child:
                                      widget.title ?? const SizedBox.shrink(),
                                ),
                              ),
                              if (widget.value != null)
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                    start: 8,
                                  ),
                                  child: DefaultTextStyle(
                                    style: effectiveDescriptionStyle.copyWith(
                                      fontSize: 15,
                                    ),
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      child: widget.value!,
                                    ),
                                  ),
                                ),
                              if (widget.trailing != null)
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                    start: 8,
                                  ),
                                  child: widget.trailing!,
                                ),
                            ],
                          ),
                          if (widget.description != null)
                            Padding(
                              padding: EdgeInsetsDirectional.only(
                                top: 2 * scaleFactor,
                              ),
                              child: DefaultTextStyle(
                                style: effectiveDescriptionStyle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                child: widget.description!,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Slider placed outside gesture detector so drag works independently
        Container(
          color: effectiveBg,
          padding: EdgeInsetsDirectional.only(
            start: widget.leading != null ? 46 : 16,
            end: 16,
            bottom: 4 * scaleFactor,
          ),
          child: SizedBox(
            width: double.infinity,
            child: CupertinoSlider(
              value: widget.sliderValue ?? widget.sliderMin,
              min: widget.sliderMin,
              max: widget.sliderMax,
              divisions: widget.sliderDivisions,
              onChanged: widget.onSliderChanged,
              activeColor: widget.sliderActiveColor,
            ),
          ),
        ),
        if (widget.description == null && additionalInfo.needToShowDivider)
          Container(
            color: effectiveBg,
            padding: const EdgeInsetsDirectional.only(start: 16),
            child: Divider(
              height: 0,
              thickness: 0.5,
              color: theme.themeData.dividerColor,
            ),
          ),
      ],
    );
  }

  Widget _buildStandardTileContent(
    BuildContext context,
    SettingsTheme theme,
    IOSSettingsTileAdditionalInfo additionalInfo,
  ) {
    final scaleFactor = MediaQuery.textScalerOf(context).scale(1);
    final effectiveTitleColor =
        widget.tileTheme?.titleColor ??
        (widget.enabled
            ? theme.themeData.settingsTileTextColor
            : theme.themeData.inactiveTitleColor);
    final effectiveTitleStyle =
        widget.tileTheme?.titleTextStyle ??
        theme.themeData.titleTextStyle?.copyWith(color: effectiveTitleColor) ??
        TextStyle(color: effectiveTitleColor, fontSize: 17);
    final effectiveBg =
        widget.tileTheme?.backgroundColor ??
        theme.themeData.settingsSectionBackground;

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
      child: FadeTransition(
        opacity: _pressAnimation,
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          color: effectiveBg,
          padding: const EdgeInsetsDirectional.only(start: 16),
          child: Row(
            children: [
              if (widget.leading != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 14.0),
                  child: IconTheme.merge(
                    data: IconThemeData(
                      color:
                          widget.tileTheme?.leadingIconColor ??
                          (widget.enabled
                              ? theme.themeData.leadingIconsColor
                              : theme.themeData.inactiveTitleColor),
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
                                style: effectiveTitleStyle,
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
    assert(
      result != null,
      'IOSSettingsTileAdditionalInfo not found. Ensure the tile is placed within an IOSSettingsSection.',
    );
    return result!;
  }
}
