import 'package:flutter/material.dart';
import 'package:settings_ui_plus/src/sections/abstract_settings_section.dart';

/// A settings section that renders an arbitrary [child] widget.
///
/// Use this to embed custom content (banners, ads, info cards) inside a
/// [SettingsList] alongside regular [SettingsSection]s.
class CustomSettingsSection extends AbstractSettingsSection {
  const CustomSettingsSection({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
