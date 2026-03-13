import 'package:flutter/material.dart';
import 'package:settings_ui_plus/settings_ui_plus.dart';

class MaterialSettingsTile extends StatelessWidget {
  const MaterialSettingsTile({
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
  final bool initialValue;
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
  Widget build(BuildContext context) {
    final theme = SettingsTheme.of(context);
    final scaleFactor = MediaQuery.textScalerOf(context).scale(1);

    // Resolve per-tile overrides on top of the inherited theme.
    final effectiveTitleColor =
        tileTheme?.titleColor ??
        (enabled
            ? theme.themeData.settingsTileTextColor
            : theme.themeData.inactiveTitleColor);
    final effectiveDescriptionColor =
        tileTheme?.descriptionColor ??
        (enabled
            ? theme.themeData.tileDescriptionTextColor
            : theme.themeData.inactiveSubtitleColor);
    final effectiveLeadingIconColor =
        tileTheme?.leadingIconColor ??
        (enabled
            ? theme.themeData.leadingIconsColor
            : theme.themeData.inactiveTitleColor);
    final effectiveTitleStyle =
        tileTheme?.titleTextStyle ??
        theme.themeData.titleTextStyle?.copyWith(color: effectiveTitleColor) ??
        TextStyle(
          color: effectiveTitleColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        );
    final effectiveDescriptionStyle =
        tileTheme?.descriptionTextStyle ??
        theme.themeData.descriptionTextStyle?.copyWith(
          color: effectiveDescriptionColor,
        ) ??
        TextStyle(color: effectiveDescriptionColor);
    final effectiveBackgroundColor =
        tileTheme?.backgroundColor ?? Colors.transparent;

    if (tileType == SettingsTileType.sliderTile) {
      return Opacity(
        opacity: enabled ? 1.0 : 0.38,
        child: IgnorePointer(
          ignoring: !enabled,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSliderTile(
                context,
                theme,
                scaleFactor,
                effectiveTitleColor: effectiveTitleColor,
                effectiveDescriptionColor: effectiveDescriptionColor,
                effectiveLeadingIconColor: effectiveLeadingIconColor,
                effectiveTitleStyle: effectiveTitleStyle,
                effectiveDescriptionStyle: effectiveDescriptionStyle,
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(
                  start: leading != null ? 64 : 16,
                  end: 16,
                ),
                child: Slider(
                  value: sliderValue ?? sliderMin,
                  min: sliderMin,
                  max: sliderMax,
                  divisions: sliderDivisions,
                  label: sliderDivisions != null
                      ? (sliderValue ?? sliderMin).toStringAsFixed(0)
                      : null,
                  onChanged: onSliderChanged,
                  activeColor: sliderActiveColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final cantShowAnimation = tileType == SettingsTileType.switchTile
        ? onToggle == null && onPressed == null
        : tileType == SettingsTileType.dropdownTile
        ? onDropdownChanged == null && onPressed == null
        : onPressed == null;

    return Semantics(
      enabled: enabled,
      toggled: tileType == SettingsTileType.switchTile ? initialValue : null,
      selected: tileType == SettingsTileType.radioTile ? selected : null,
      inMutuallyExclusiveGroup: tileType == SettingsTileType.radioTile
          ? true
          : null,
      button:
          tileType != SettingsTileType.switchTile &&
          tileType != SettingsTileType.radioTile,
      hint: tileType == SettingsTileType.switchTile
          ? (onToggle != null ? 'Double-tap to toggle' : null)
          : tileType == SettingsTileType.sliderTile
          ? (onSliderChanged != null || onPressed != null
                ? 'Adjust with slider'
                : null)
          : tileType == SettingsTileType.dropdownTile
          ? (onDropdownChanged != null ? 'Double-tap to select' : null)
          : (onPressed != null ? 'Double-tap to activate' : null),
      child: Opacity(
        opacity: enabled ? 1.0 : 0.38,
        child: IgnorePointer(
          ignoring: !enabled,
          child: Material(
            color: selected
                ? Theme.of(context).colorScheme.primary.withAlpha(20)
                : effectiveBackgroundColor,
            child: InkWell(
              onTap: cantShowAnimation
                  ? null
                  : () {
                      if (tileType == SettingsTileType.switchTile) {
                        onToggle?.call(!initialValue);
                      } else {
                        onPressed?.call(context);
                      }
                    },
              onLongPress: onLongPress == null
                  ? null
                  : () => onLongPress!.call(context),
              highlightColor: theme.themeData.tileHighlightColor,
              hoverColor: theme.themeData.tileHighlightColor?.withAlpha(50),
              focusColor: Theme.of(context).colorScheme.primary.withAlpha(30),
              mouseCursor: cantShowAnimation
                  ? SystemMouseCursors.basic
                  : SystemMouseCursors.click,
              child: Row(
                children: [
                  if (leading != null)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 24),
                      child: IconTheme(
                        data: IconTheme.of(
                          context,
                        ).copyWith(color: effectiveLeadingIconColor),
                        child: leading!,
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: 24,
                        end: 24,
                        bottom: 16 * scaleFactor,
                        top: 16 * scaleFactor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DefaultTextStyle(
                            style: effectiveTitleStyle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            child: title ?? const SizedBox.shrink(),
                          ),
                          if (value != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: DefaultTextStyle(
                                style: effectiveDescriptionStyle,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: value!,
                                ),
                              ),
                            ),
                          if (description != null)
                            Padding(
                              padding: EdgeInsets.only(
                                top: value != null ? 2.0 : 4.0,
                              ),
                              child: DefaultTextStyle(
                                style: effectiveDescriptionStyle,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                child: description!,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (trailing != null &&
                      tileType == SettingsTileType.switchTile)
                    Row(
                      children: [
                        trailing!,
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: 8),
                          child: Switch(
                            value: initialValue,
                            onChanged: onToggle,
                            activeTrackColor: enabled
                                ? activeSwitchColor
                                : null,
                          ),
                        ),
                      ],
                    )
                  else if (tileType == SettingsTileType.switchTile)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 16,
                        end: 8,
                      ),
                      child: Switch(
                        value: initialValue,
                        onChanged: onToggle,
                        activeTrackColor: enabled ? activeSwitchColor : null,
                      ),
                    )
                  else if (tileType == SettingsTileType.dropdownTile &&
                      dropdownItems != null)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        underline: const SizedBox.shrink(),
                        onChanged: onDropdownChanged,
                        items: dropdownItems!.map((item) {
                          return DropdownMenuItem<String>(
                            value: item.value,
                            enabled: item.enabled,
                            child: item.child,
                          );
                        }).toList(),
                      ),
                    )
                  else if (trailing != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: trailing!,
                    )
                  else if (selected)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliderTile(
    BuildContext context,
    SettingsTheme theme,
    double scaleFactor, {
    required Color? effectiveTitleColor,
    required Color? effectiveDescriptionColor,
    required Color? effectiveLeadingIconColor,
    required TextStyle effectiveTitleStyle,
    required TextStyle effectiveDescriptionStyle,
  }) {
    return Semantics(
      enabled: enabled,
      hint: onSliderChanged != null || onPressed != null
          ? 'Adjust with slider'
          : null,
      child: Material(
        color: tileTheme?.backgroundColor ?? Colors.transparent,
        child: InkWell(
          onTap: onPressed == null ? null : () => onPressed!.call(context),
          onLongPress: onLongPress == null
              ? null
              : () => onLongPress!.call(context),
          highlightColor: theme.themeData.tileHighlightColor,
          hoverColor: theme.themeData.tileHighlightColor?.withAlpha(50),
          focusColor: Theme.of(context).colorScheme.primary.withAlpha(30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leading != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 24),
                  child: IconTheme(
                    data: IconTheme.of(
                      context,
                    ).copyWith(color: effectiveLeadingIconColor),
                    child: leading!,
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: 24,
                    end: 24,
                    top: 16 * scaleFactor,
                    bottom: 8 * scaleFactor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DefaultTextStyle(
                              style: effectiveTitleStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              child: title ?? const SizedBox.shrink(),
                            ),
                          ),
                          if (value != null)
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: 8,
                              ),
                              child: DefaultTextStyle(
                                style: TextStyle(
                                  color: effectiveDescriptionColor,
                                  fontSize: 14,
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: value!,
                                ),
                              ),
                            ),
                          if (trailing != null)
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: 8,
                              ),
                              child: trailing!,
                            ),
                        ],
                      ),
                      if (description != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: DefaultTextStyle(
                            style: effectiveDescriptionStyle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            child: description!,
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
    );
  }
}
