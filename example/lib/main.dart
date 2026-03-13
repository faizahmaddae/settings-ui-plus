import 'package:flutter/material.dart';
import 'package:settings_ui_plus/settings_ui_plus.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Settings UI Plus Demo',
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: SettingsScreen(
        themeMode: _themeMode,
        onThemeModeChanged: _setThemeMode,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Main settings screen
// ---------------------------------------------------------------------------

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Preferences
  bool _darkMode = false;
  bool _notifications = true;
  String _language = 'English';
  String _timezone = 'UTC';

  // Appearance
  double _fontSize = 16;
  double _brightness = 75;
  String _accentColor = 'Deep Purple';

  // Privacy
  bool _faceId = true;
  bool _dataSharing = false;
  bool _analytics = true;

  @override
  void didUpdateWidget(SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.themeMode != oldWidget.themeMode) {
      _darkMode = widget.themeMode == ThemeMode.dark;
    }
  }

  void _toggleDarkMode(bool value) {
    setState(() => _darkMode = value);
    widget.onThemeModeChanged(value ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: SettingsList(
        // Demonstrates fromColorScheme factory — one line to match your theme
        lightTheme: SettingsThemeData.fromColorScheme(
          Theme.of(context).colorScheme,
        ),
        darkTheme: const SettingsThemeData(
          settingsListBackground: Color(0xFF1C1C1E),
        ),
        sections: [
          // ── Account ────────────────────────────────────────────
          SettingsSection(
            title: const Text('Account'),
            tiles: [
              SettingsTile.navigation(
                title: const Text('Profile'),
                leading: const Icon(Icons.person),
                value: const Text('Alex Johnson'),
                onPressed: (context) => _push(context, const ProfileScreen()),
              ),
              SettingsTile.navigation(
                title: const Text('Email'),
                leading: const Icon(Icons.email_outlined),
                value: const Text('alex@example.com'),
                onPressed: (context) => _pushDetail(
                  context,
                  'Email',
                  'Manage your email address and verification status.',
                ),
              ),
              SettingsTile.navigation(
                title: const Text('Phone Number'),
                leading: const Icon(Icons.phone_outlined),
                value: const Text('+1 (555) 012-3456'),
                onPressed: (context) => _pushDetail(
                  context,
                  'Phone Number',
                  'Update your phone number for two-factor authentication.',
                ),
              ),
              SettingsTile.navigation(
                title: const Text('Change Password'),
                leading: const Icon(Icons.lock_outline),
                // Demonstrates onLongPress
                onLongPress: (context) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tip: Use a strong, unique password'),
                    ),
                  );
                },
                onPressed: (context) => _pushDetail(
                  context,
                  'Change Password',
                  'Enter your current and new password.',
                ),
              ),
              SettingsTile.navigation(
                title: const Text('Sign Out'),
                leading: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.error,
                ),
                // Demonstrates per-tile theming via tileTheme
                tileTheme: SettingsTileThemeData(
                  titleColor: Theme.of(context).colorScheme.error,
                ),
                onPressed: (context) {
                  showDialog<void>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Sign Out'),
                      content: const Text('Are you sure you want to sign out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Signed out')),
                            );
                          },
                          child: const Text('Sign Out'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),

          // ── Preferences ────────────────────────────────────────
          SettingsSection(
            title: const Text('Preferences'),
            tiles: [
              SettingsTile.switchTile(
                title: const Text('Dark Mode'),
                leading: const Icon(Icons.dark_mode_outlined),
                initialValue: _darkMode,
                onToggle: _toggleDarkMode,
              ),
              SettingsTile.switchTile(
                title: const Text('Notifications'),
                leading: const Icon(Icons.notifications_outlined),
                description: const Text('Receive push notifications'),
                initialValue: _notifications,
                // Demonstrates activeSwitchColor
                activeSwitchColor: Colors.green,
                onToggle: (value) => setState(() => _notifications = value),
              ),
              SettingsTile.switchTile(
                title: const Text('Location Services'),
                leading: const Icon(Icons.location_on_outlined),
                description: const Text('Permission not granted'),
                initialValue: false,
                onToggle: (_) {},
                // Demonstrates disabled state
                enabled: false,
              ),
              SettingsTile.navigation(
                title: const Text('Language'),
                leading: const Icon(Icons.language),
                value: Text(_language),
                searchTerms: const ['language', 'locale', 'translation'],
                onPressed: (context) {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => LanguageScreen(
                        selected: _language,
                        onChanged: (lang) {
                          setState(() => _language = lang);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  );
                },
              ),
              // Demonstrates dropdownTile
              SettingsTile.dropdownTile(
                title: const Text('Timezone'),
                leading: const Icon(Icons.schedule),
                searchTerms: const ['timezone', 'time zone', 'clock'],
                dropdownValue: _timezone,
                dropdownItems: const [
                  DropdownSettingsItem(value: 'UTC', child: Text('UTC')),
                  DropdownSettingsItem(
                    value: 'EST',
                    child: Text('Eastern (EST)'),
                  ),
                  DropdownSettingsItem(
                    value: 'PST',
                    child: Text('Pacific (PST)'),
                  ),
                  DropdownSettingsItem(
                    value: 'CET',
                    child: Text('Central European (CET)'),
                  ),
                  DropdownSettingsItem(
                    value: 'JST',
                    child: Text('Japan (JST)'),
                  ),
                ],
                onDropdownChanged: (value) {
                  if (value != null) setState(() => _timezone = value);
                },
              ),
            ],
          ),

          // ── Appearance ─────────────────────────────────────────
          SettingsSection(
            title: const Text('Appearance'),
            tiles: [
              // Slider with icon, description, and divisions
              // Demonstrates AnimatedSwitcher – provide a ValueKey on value
              // widget so the crossfade animates when the value changes.
              SettingsTile.sliderTile(
                title: const Text('Font Size'),
                leading: const Icon(Icons.text_fields),
                sliderValue: _fontSize,
                sliderMin: 10,
                sliderMax: 30,
                sliderDivisions: 20,
                value: Text(
                  '${_fontSize.round()}',
                  key: ValueKey(_fontSize.round()),
                ),
                description: const Text('Adjust the base font size'),
                searchTerms: const ['font', 'size', 'text'],
                onSliderChanged: (value) => setState(() => _fontSize = value),
              ),
              // Slider without icon, continuous, with custom color
              SettingsTile.sliderTile(
                title: const Text('Display Brightness'),
                sliderValue: _brightness,
                sliderMin: 0,
                sliderMax: 100,
                value: Text('${_brightness.round()}%'),
                sliderActiveColor: Colors.amber,
                onSliderChanged: (value) => setState(() => _brightness = value),
              ),
              SettingsTile.navigation(
                title: const Text('App Theme'),
                leading: const Icon(Icons.palette_outlined),
                value: Text(_darkMode ? 'Dark' : 'Light'),
                onPressed: (context) => _pushDetail(
                  context,
                  'App Theme',
                  'Choose between Light, Dark, or System default.',
                ),
              ),
              SettingsTile.navigation(
                title: const Text('Accent Color'),
                leading: const Icon(Icons.color_lens_outlined),
                value: Text(_accentColor),
                onPressed: (context) {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => AccentColorScreen(
                        selected: _accentColor,
                        onChanged: (color) {
                          setState(() => _accentColor = color);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          // ── Privacy ────────────────────────────────────────────
          SettingsSection(
            title: const Text('Privacy'),
            // Demonstrates section footer
            footer: const Text(
              'Your data is encrypted end-to-end and never shared '
              'without your explicit consent.',
            ),
            tiles: [
              SettingsTile.switchTile(
                title: const Text('Face ID / Biometrics'),
                leading: const Icon(Icons.fingerprint),
                initialValue: _faceId,
                onToggle: (value) => setState(() => _faceId = value),
              ),
              SettingsTile.switchTile(
                title: const Text('Data Sharing'),
                leading: const Icon(Icons.share_outlined),
                description: const Text(
                  'Share anonymous usage data to improve the app',
                ),
                initialValue: _dataSharing,
                onToggle: (value) => setState(() => _dataSharing = value),
              ),
              SettingsTile.switchTile(
                title: const Text('Analytics'),
                leading: const Icon(Icons.analytics_outlined),
                initialValue: _analytics,
                onToggle: (value) => setState(() => _analytics = value),
              ),
            ],
          ),

          // ── About (expandable, starts collapsed) ───────────────
          SettingsSection(
            title: const Text('About'),
            // Demonstrates expandable section — tap the title to open
            expandable: true,
            initiallyExpanded: false,
            tiles: [
              SettingsTile.navigation(
                title: const Text('Terms of Service'),
                leading: const Icon(Icons.description_outlined),
                onPressed: (context) => _pushDetail(
                  context,
                  'Terms of Service',
                  'By using this application you agree to our terms '
                      'and conditions. Please read them carefully.',
                ),
              ),
              SettingsTile.navigation(
                title: const Text('Privacy Policy'),
                leading: const Icon(Icons.privacy_tip_outlined),
                onPressed: (context) => _pushDetail(
                  context,
                  'Privacy Policy',
                  'We respect your privacy. This policy explains '
                      'how we collect and use your personal data.',
                ),
              ),
              SettingsTile.navigation(
                title: const Text('Open Source Licenses'),
                leading: const Icon(Icons.collections_bookmark_outlined),
                onPressed: (context) => showLicensePage(
                  context: context,
                  applicationName: 'Settings UI Plus Demo',
                  applicationVersion: '0.2.3',
                ),
              ),
            ],
          ),

          // ── New Features Demos ─────────────────────────────────
          SettingsSection(
            title: const Text('Feature Demos'),
            tiles: [
              SettingsTile.navigation(
                title: const Text('Searchable Settings'),
                leading: const Icon(Icons.search),
                description: const Text('SearchableSettingsList widget'),
                onPressed: (context) =>
                    _push(context, const SearchableSettingsDemo()),
              ),
              SettingsTile.navigation(
                title: const Text('Sliver Settings'),
                leading: const Icon(Icons.view_list),
                description: const Text(
                  'SliverSettingsList in CustomScrollView',
                ),
                onPressed: (context) =>
                    _push(context, const SliverSettingsDemo()),
              ),
            ],
          ),

          // ── CustomSettingsSection for footer branding ───────────
          CustomSettingsSection(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Center(
                child: Text(
                  'settings_ui_plus v0.2.3',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }

  void _pushDetail(BuildContext context, String title, String body) {
    _push(context, DetailScreen(title: title, body: body));
  }
}

// ---------------------------------------------------------------------------
// Profile screen — demonstrates a nested SettingsList
// ---------------------------------------------------------------------------

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SettingsList(
        sections: [
          // Demonstrates CustomSettingsSection with arbitrary content
          CustomSettingsSection(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Text(
                      'AJ',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Alex Johnson',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'alex@example.com',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SettingsSection(
            title: const Text('Personal Information'),
            tiles: [
              SettingsTile(
                title: const Text('Full Name'),
                value: const Text('Alex Johnson'),
                leading: const Icon(Icons.badge_outlined),
              ),
              SettingsTile(
                title: const Text('Date of Birth'),
                value: const Text('January 15, 1990'),
                leading: const Icon(Icons.cake_outlined),
              ),
              SettingsTile(
                title: const Text('Member Since'),
                value: const Text('March 2024'),
                leading: const Icon(Icons.calendar_today_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Language selection — demonstrates radioTile for single selection
// ---------------------------------------------------------------------------

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final String selected;
  final ValueChanged<String> onChanged;

  static const _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Japanese',
    'Korean',
    'Chinese',
    'Arabic',
  ];

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

// ---------------------------------------------------------------------------
// Accent color selection — demonstrates radioTile with leading icons
// ---------------------------------------------------------------------------

class AccentColorScreen extends StatelessWidget {
  const AccentColorScreen({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final String selected;
  final ValueChanged<String> onChanged;

  static const _colors = {
    'Deep Purple': Colors.deepPurple,
    'Blue': Colors.blue,
    'Teal': Colors.teal,
    'Green': Colors.green,
    'Orange': Colors.orange,
    'Red': Colors.red,
    'Pink': Colors.pink,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accent Color')),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Choose Color'),
            tiles: [
              for (final entry in _colors.entries)
                SettingsTile.radioTile(
                  title: Text(entry.key),
                  leading: Icon(Icons.circle, color: entry.value),
                  selected: entry.key == selected,
                  onPressed: (_) => onChanged(entry.key),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Generic detail screen
// ---------------------------------------------------------------------------

class DetailScreen extends StatelessWidget {
  const DetailScreen({required this.title, required this.body, super.key});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(body, style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SearchableSettingsList demo
// ---------------------------------------------------------------------------

class SearchableSettingsDemo extends StatelessWidget {
  const SearchableSettingsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Searchable Settings')),
      body: SearchableSettingsList(
        searchHint: 'Search settings\u2026',
        sections: [
          SettingsSection(
            title: const Text('General'),
            tiles: [
              SettingsTile.navigation(
                title: const Text('Language'),
                leading: const Icon(Icons.language),
                searchTerms: const ['language', 'locale'],
              ),
              SettingsTile.navigation(
                title: const Text('Notifications'),
                leading: const Icon(Icons.notifications_outlined),
                searchTerms: const ['notifications', 'alerts', 'push'],
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Display'),
            tiles: [
              SettingsTile.navigation(
                title: const Text('Theme'),
                leading: const Icon(Icons.palette_outlined),
                searchTerms: const ['theme', 'dark mode', 'light mode'],
              ),
              SettingsTile.navigation(
                title: const Text('Font Size'),
                leading: const Icon(Icons.text_fields),
                searchTerms: const ['font', 'size', 'text'],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SliverSettingsList demo
// ---------------------------------------------------------------------------

class SliverSettingsDemo extends StatelessWidget {
  const SliverSettingsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(title: const Text('Sliver Settings')),
          SliverSettingsList(
            sections: [
              SettingsSection(
                title: const Text('Section One'),
                tiles: [
                  SettingsTile.navigation(
                    title: const Text('Item A'),
                    leading: const Icon(Icons.star_outline),
                  ),
                  SettingsTile.navigation(
                    title: const Text('Item B'),
                    leading: const Icon(Icons.star_outline),
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('Section Two'),
                tiles: [
                  SettingsTile.switchTile(
                    title: const Text('Toggle'),
                    initialValue: true,
                    onToggle: (_) {},
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
