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
                value: const Text('English'),
                leading: const Icon(Icons.language),
                onPressed: (context) {},
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
            ],
          ),
          SettingsSection(
            title: const Text('Misc'),
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
                    'settings_ui_plus v0.1.0',
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
