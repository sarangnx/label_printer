import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:label_printer/models/company_model.dart';
import 'package:label_printer/router.dart' as router;

void main() {
  runApp(ChangeNotifierProvider<CompanyModel>(
    create: (context) => CompanyModel(),
    child: App(),
  ));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Label Printer',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: router.generateRoute,
      initialRoute: '/',
    );
  }
}
