/// Build native-looking settings screens in minutes.
///
/// A single API that adapts to Material and Cupertino design guidelines
/// automatically. Import this library and use [SettingsList], [SettingsSection],
/// and [SettingsTile] to compose your settings UI.
library;

export 'package:settings_ui_plus/src/list/searchable_settings_list.dart';
export 'package:settings_ui_plus/src/list/settings_list.dart'
    show ApplicationType, SettingsList;
export 'package:settings_ui_plus/src/list/sliver_settings_list.dart';
export 'package:settings_ui_plus/src/sections/abstract_settings_section.dart';
export 'package:settings_ui_plus/src/sections/custom_settings_section.dart';
export 'package:settings_ui_plus/src/sections/settings_section.dart';
export 'package:settings_ui_plus/src/tiles/abstract_settings_tile.dart';
export 'package:settings_ui_plus/src/tiles/custom_settings_tile.dart';
export 'package:settings_ui_plus/src/tiles/settings_tile.dart';
export 'package:settings_ui_plus/src/utils/platform_utils.dart'
    show DevicePlatform;
export 'package:settings_ui_plus/src/utils/settings_theme.dart';
