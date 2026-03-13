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

  @override
  Widget build(BuildContext context) {
    final theme = SettingsTheme.of(context);
    final scaleFactor = MediaQuery.textScalerOf(context).scale(1);

    if (tileType == SettingsTileType.sliderTile) {
      return _buildSliderTile(context, theme, scaleFactor);
    }

    final cantShowAnimation = tileType == SettingsTileType.switchTile
        ? onToggle == null && onPressed == null
        : onPressed == null;

    return Semantics(
      enabled: enabled,
      toggled: tileType == SettingsTileType.switchTile ? initialValue : null,
      button: tileType != SettingsTileType.switchTile,
      hint: tileType == SettingsTileType.switchTile
          ? (onToggle != null ? 'Double-tap to toggle' : null)
          : tileType == SettingsTileType.sliderTile
              ? (onSliderChanged != null || onPressed != null
                  ? 'Adjust with slider'
                  : null)
              : (onPressed != null ? 'Double-tap to activate' : null),
      child: Opacity(
        opacity: enabled ? 1.0 : 0.38,
        child: IgnorePointer(
        ignoring: !enabled,
        child: Material(
          color: selected
              ? Theme.of(context).colorScheme.primary.withAlpha(20)
              : Colors.transparent,
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
            onLongPress:
                onLongPress == null ? null : () => onLongPress!.call(context),
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
                      data: IconTheme.of(context).copyWith(
                        color: enabled
                            ? theme.themeData.leadingIconsColor
                            : theme.themeData.inactiveTitleColor,
                      ),
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
                          style: theme.themeData.titleTextStyle?.copyWith(
                                color: enabled
                                    ? theme.themeData.settingsTileTextColor
                                    : theme.themeData.inactiveTitleColor,
                              ) ??
                              TextStyle(
                                color: enabled
                                    ? theme.themeData.settingsTileTextColor
                                    : theme.themeData.inactiveTitleColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          child: title ?? const SizedBox.shrink(),
                        ),
                        if (value != null || description != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: DefaultTextStyle(
                              style:
                                  theme.themeData.descriptionTextStyle?.copyWith(
                                        color: enabled
                                            ? theme.themeData
                                                .tileDescriptionTextColor
                                            : theme
                                                .themeData.inactiveSubtitleColor,
                                      ) ??
                                      TextStyle(
                                        color: enabled
                                            ? theme.themeData
                                                .tileDescriptionTextColor
                                            : theme
                                                .themeData.inactiveSubtitleColor,
                                      ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              child: value ?? description!,
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
                          activeTrackColor: enabled ? activeSwitchColor : null,
                        ),
                      ),
                    ],
                  )
                else if (tileType == SettingsTileType.switchTile)
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.only(start: 16, end: 8),
                    child: Switch(
                      value: initialValue,
                      onChanged: onToggle,
                      activeTrackColor: enabled ? activeSwitchColor : null,
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
    double scaleFactor,
  ) {
    return Semantics(
      enabled: enabled,
      hint: onSliderChanged != null || onPressed != null
          ? 'Adjust with slider'
          : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.38,
        child: IgnorePointer(
          ignoring: !enabled,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onLongPress: onLongPress == null
                ? null
                : () => onLongPress!.call(context),
            child: Container(
            color: Colors.transparent,
            padding: EdgeInsetsDirectional.only(
              top: 12 * scaleFactor,
              bottom: 8 * scaleFactor,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Leading icon, vertically centered
                if (leading != null)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 24),
                    child: IconTheme(
                      data: IconTheme.of(context).copyWith(
                        color: enabled
                            ? theme.themeData.leadingIconsColor
                            : theme.themeData.inactiveTitleColor,
                      ),
                      child: leading!,
                    ),
                  ),
                // Content column: title row + description + slider
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title row: title + value + trailing
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                          start: 24,
                          end: 24,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: DefaultTextStyle(
                                style: theme.themeData.titleTextStyle?.copyWith(
                                      color: enabled
                                          ? theme.themeData.settingsTileTextColor
                                          : theme.themeData.inactiveTitleColor,
                                    ) ??
                                    TextStyle(
                                      color: enabled
                                          ? theme.themeData.settingsTileTextColor
                                          : theme.themeData.inactiveTitleColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                child: title ?? const SizedBox.shrink(),
                              ),
                            ),
                            if (value != null)
                              Padding(
                                padding: const EdgeInsetsDirectional.only(start: 8),
                                child: DefaultTextStyle(
                                  style: TextStyle(
                                    color: enabled
                                        ? theme.themeData.tileDescriptionTextColor
                                        : theme.themeData.inactiveSubtitleColor,
                                    fontSize: 14,
                                  ),
                                  child: value!,
                                ),
                              ),
                            if (trailing != null)
                              Padding(
                                padding: const EdgeInsetsDirectional.only(start: 8),
                                child: trailing!,
                              ),
                          ],
                        ),
                      ),
                      // Description below title if present
                      if (description != null)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 24,
                            end: 24,
                            top: 4,
                          ),
                          child: DefaultTextStyle(
                            style:
                                theme.themeData.descriptionTextStyle?.copyWith(
                                      color: enabled
                                          ? theme.themeData.tileDescriptionTextColor
                                          : theme.themeData.inactiveSubtitleColor,
                                    ) ??
                                    TextStyle(
                                      color: enabled
                                          ? theme.themeData.tileDescriptionTextColor
                                          : theme.themeData.inactiveSubtitleColor,
                                    ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            child: description!,
                          ),
                        ),
                      // Slider aligned under the text content
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                          start: 8,
                          end: 8,
                        ),
                        child: Slider(
                          value: sliderValue ?? sliderMin,
                          min: sliderMin,
                          max: sliderMax,
                          divisions: sliderDivisions,
                          label: sliderDivisions != null
                              ? (sliderValue ?? sliderMin).toStringAsFixed(0)
                              : null,
                          onChanged: enabled ? onSliderChanged : null,
                          activeColor: sliderActiveColor,
                        ),
                      ),
                    ],
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
}
