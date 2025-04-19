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
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      onGenerateRoute: router.generateRoute,
      initialRoute: '/',
    );
  }
}
