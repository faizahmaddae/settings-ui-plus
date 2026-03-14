import 'package:flutter/material.dart';
import 'package:settings_ui_plus/src/list/settings_list.dart';
import 'package:settings_ui_plus/src/sections/abstract_settings_section.dart';
import 'package:settings_ui_plus/src/sections/settings_section.dart';
import 'package:settings_ui_plus/src/tiles/abstract_settings_tile.dart';
import 'package:settings_ui_plus/src/tiles/settings_tile.dart';
import 'package:settings_ui_plus/src/utils/platform_utils.dart';
import 'package:settings_ui_plus/src/utils/settings_theme.dart';

/// A [SettingsList] wrapped with a search bar that filters sections and tiles
/// whose [SettingsTile.searchTerms] match the query.
///
/// Tiles that do not set [SettingsTile.searchTerms] are hidden when a query
/// is active. Sections with no matching tiles are omitted entirely.
///
/// ```dart
/// SearchableSettingsList(
///   searchHint: 'Search settings…',
///   sections: [
///     SettingsSection(
///       title: Text('General'),
///       tiles: [
///         SettingsTile.navigation(
///           title: Text('Language'),
///           searchTerms: ['language', 'locale'],
///         ),
///       ],
///     ),
///   ],
/// )
/// ```
class SearchableSettingsList extends StatefulWidget {
  const SearchableSettingsList({
    required this.sections,
    this.shrinkWrap = false,
    this.physics,
    this.platform,
    this.lightTheme,
    this.darkTheme,
    this.brightness,
    this.contentPadding,
    this.applicationType = ApplicationType.material,
    this.searchHint,
    this.searchController,
    this.searchBarPadding,
    super.key,
  });

  /// Same parameters as [SettingsList].
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final DevicePlatform? platform;
  final SettingsThemeData? lightTheme;
  final SettingsThemeData? darkTheme;
  final Brightness? brightness;
  final EdgeInsetsGeometry? contentPadding;
  final List<AbstractSettingsSection> sections;
  final ApplicationType applicationType;

  /// Placeholder text shown in the search bar.
  final String? searchHint;

  /// Optional external [TextEditingController] for the search bar. When
  /// provided, the widget does **not** create its own controller.
  final TextEditingController? searchController;

  /// Padding around the search bar. Defaults to horizontal 16, vertical 8.
  final EdgeInsetsGeometry? searchBarPadding;

  @override
  State<SearchableSettingsList> createState() => _SearchableSettingsListState();
}

class _SearchableSettingsListState extends State<SearchableSettingsList> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.searchController ?? TextEditingController();
    _controller.addListener(_onQueryChanged);
  }

  @override
  void didUpdateWidget(SearchableSettingsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchController != oldWidget.searchController) {
      oldWidget.searchController?.removeListener(_onQueryChanged);
      _controller = widget.searchController ?? TextEditingController();
      _controller.addListener(_onQueryChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onQueryChanged);
    if (widget.searchController == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onQueryChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text.trim().toLowerCase();
    final filtered = query.isEmpty
        ? widget.sections
        : _filterSections(widget.sections, query);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding:
              widget.searchBarPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: widget.searchHint ?? 'Search',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _controller.clear(),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Flexible(
          child: SettingsList(
            sections: filtered,
            shrinkWrap: widget.shrinkWrap,
            physics: widget.physics,
            platform: widget.platform,
            lightTheme: widget.lightTheme,
            darkTheme: widget.darkTheme,
            brightness: widget.brightness,
            contentPadding: widget.contentPadding,
            applicationType: widget.applicationType,
          ),
        ),
      ],
    );
  }

  /// Filters sections to only include tiles whose [SettingsTile.searchTerms]
  /// contain the query substring. Sections that end up empty are excluded.
  List<AbstractSettingsSection> _filterSections(
    List<AbstractSettingsSection> sections,
    String query,
  ) {
    final result = <AbstractSettingsSection>[];

    for (final section in sections) {
      if (section is SettingsSection) {
        final matchedTiles = <AbstractSettingsTile>[];

        for (final tile in section.tiles) {
          if (tile is SettingsTile && tile.searchTerms != null) {
            final matches = tile.searchTerms!.any(
              (term) => term.toLowerCase().contains(query),
            );
            if (matches) {
              matchedTiles.add(tile);
            }
          }
        }

        if (matchedTiles.isNotEmpty) {
          result.add(
            SettingsSection(
              tiles: matchedTiles,
              title: section.title,
              margin: section.margin,
              footer: section.footer,
              expandable: section.expandable,
              initiallyExpanded: section.initiallyExpanded,
            ),
          );
        }
      } else {
        // Non-SettingsSection sections (e.g. CustomSettingsSection) are
        // kept as-is so they remain visible during search.
        result.add(section);
      }
    }

    return result;
  }
}
