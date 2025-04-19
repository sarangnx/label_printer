import 'package:flutter/material.dart';

import 'router.dart' as router;
import 'theme/app_theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Label Printer',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // or .light / .dark
      onGenerateRoute: router.generateRoute,
      initialRoute: '/',
    );
  }
}
