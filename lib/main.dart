import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/company_model.dart';
import 'router.dart' as router;
import 'theme/app_theme.dart';

void main() {
  runApp(ChangeNotifierProvider<CompanyModel>(create: (context) => CompanyModel(), child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Label Printer',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // TODO: Add a theme switcher
      themeMode: ThemeMode.light,
      onGenerateRoute: router.generateRoute,
      initialRoute: '/',
    );
  }
}
