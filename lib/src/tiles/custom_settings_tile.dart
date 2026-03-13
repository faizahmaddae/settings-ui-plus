import 'package:flutter/material.dart';
import 'package:settings_ui_plus/src/tiles/abstract_settings_tile.dart';

/// A settings tile that renders an arbitrary [child] widget.
///
/// Use this to embed custom content inside a [SettingsSection] alongside
/// regular [SettingsTile]s.
class CustomSettingsTile extends AbstractSettingsTile {
  const CustomSettingsTile({required this.child, super.key});

  /// The custom widget to render as a tile.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
