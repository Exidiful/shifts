import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_constants.dart';
import 'core/theme.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/employee_list_page.dart';
import 'presentation/pages/shift_list_page.dart';
import 'presentation/pages/team_pages.dart';
import 'presentation/pages/shift_period_pages.dart';

final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: HomePage(
        onThemeToggle: (bool value) {
          ref.read(themeProvider.notifier).state = value ? ThemeMode.light : ThemeMode.dark;
        },
        isDarkMode: themeMode == ThemeMode.dark,
      ),
      routes: {
        '/employees': (context) => const EmployeeListPage(),
        '/shifts': (context) => const ShiftListPage(),
        '/teams': (context) => const TeamListPage(),
        '/periods': (context) => const ShiftPeriodListPage(),
      },
    );
  }
}
