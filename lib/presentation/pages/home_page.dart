import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme.dart';

class HomePage extends ConsumerWidget {
  final Function(bool) onThemeToggle;
  final bool isDarkMode;

  const HomePage({
    Key? key,
    required this.onThemeToggle,
    required this.isDarkMode,
  }) : super(key: key);

  static const _options = [
    {'title': 'Employees', 'icon': FontAwesomeIcons.userFriends, 'route': '/employees'},
    {'title': 'Shifts', 'icon': FontAwesomeIcons.calendarAlt, 'route': '/shifts'},
    {'title': 'Teams', 'icon': FontAwesomeIcons.users, 'route': '/teams'},
    {'title': 'Periods', 'icon': FontAwesomeIcons.clock, 'route': '/periods'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customTheme = Theme.of(context).extension<CustomThemeExtension>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Shifts App', style: Theme.of(context).textTheme.headlineMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: _buildDrawer(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: _options.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                return _buildGridItem(context, _options[index], customTheme);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Text(
              'Shifts App',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          SwitchListTile(
            title: Text('Dark Mode', style: Theme.of(context).textTheme.bodyLarge),
            value: isDarkMode,
            onChanged: onThemeToggle,
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, Map<String, dynamic> option, CustomThemeExtension? customTheme) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: customTheme?.cardBackgroundColor,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, option['route'] as String),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              option['icon'] as IconData,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              option['title'] as String,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
