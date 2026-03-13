import 'package:flutter/material.dart';
import 'package:settings_ui_plus/settings_ui_plus.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings UI Plus Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      darkTheme: ThemeData.dark(),
      home: const SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;
  bool _locationServices = false;
  String _language = 'English';
  double _fontSize = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SettingsList( 
        sections: [
          SettingsSection(
            title: const Text('Common'),
            tiles: [
              SettingsTile(
                title: const Text('Language'),
                value: Text(_language),
                leading: const Icon(Icons.language),
                onPressed: (context) {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => _LanguageScreen(
                        selected: _language,
                        onChanged: (lang) {
                          setState(() => _language = lang);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  );
                },
                onLongPress: (context) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Long pressed Language')),
                  );
                },
              ),
              SettingsTile(
                title: const Text('Environment'),
                value: const Text('Production'),
                leading: const Icon(Icons.cloud_queue),
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Account'),
            footer: const Text('Your account data is stored securely on our servers.'),
            tiles: [
              SettingsTile.navigation(
                title: const Text('Phone number'),
                leading: const Icon(Icons.phone),
              ),
              SettingsTile.navigation(
                title: const Text('Email'),
                leading: const Icon(Icons.email),
              ),
              SettingsTile.navigation(
                title: const Text('Sign out'),
                leading: const Icon(Icons.exit_to_app),
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Preferences'),
            tiles: [
              SettingsTile.switchTile(
                title: const Text('Dark Mode'),
                leading: const Icon(Icons.dark_mode),
                initialValue: _darkMode,
                onToggle: (value) {
                  setState(() => _darkMode = value);
                },
              ),
              SettingsTile.switchTile(
                title: const Text('Enable Notifications'),
                leading: const Icon(Icons.notifications_active),
                initialValue: _notifications,
                onToggle: (value) {
                  setState(() => _notifications = value);
                },
              ),
              SettingsTile.switchTile(
                title: const Text('Location Services'),
                leading: const Icon(Icons.location_on),
                initialValue: _locationServices,
                onToggle: (value) {
                  setState(() => _locationServices = value);
                },
                enabled: false,
                description: const Text('Requires permission'),
              ),
              SettingsTile.sliderTile(
                title: const Text('Font Size'),
                leading: const Icon(Icons.text_fields),
                sliderValue: _fontSize,
                sliderMin: 10,
                sliderMax: 30,
                sliderDivisions: 20,
                value: Text('${_fontSize.round()}'),
                onSliderChanged: (value) {
                  setState(() => _fontSize = value);
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Misc'),
            expandable: true,
            initiallyExpanded: false,
            tiles: [
              SettingsTile(
                title: const Text('Terms of Service'),
                leading: const Icon(Icons.description),
              ),
              SettingsTile(
                title: const Text('Open Source Licenses'),
                leading: const Icon(Icons.collections_bookmark),
              ),
              const CustomSettingsTile(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text(
                    'settings_ui_plus v0.2.0',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Screen demonstrating [SettingsTile.radioTile] for single-selection.
class _LanguageScreen extends StatelessWidget {
  const _LanguageScreen({
    required this.selected,
    required this.onChanged,
  });

  final String selected;
  final ValueChanged<String> onChanged;

  static const _languages = ['English', 'Spanish', 'French', 'German', 'Japanese'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Language')),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Choose Language'),
            tiles: [
              for (final lang in _languages)
                SettingsTile.radioTile(
                  title: Text(lang),
                  selected: lang == selected,
                  onPressed: (_) => onChanged(lang),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
