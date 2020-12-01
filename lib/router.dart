import 'package:flutter/material.dart';

import 'package:label_printer/pages/home.dart';
import 'package:label_printer/pages/add.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => HomePage());
    case '/add':
      return MaterialPageRoute(builder: (context) => AddItem());
    default:
      return MaterialPageRoute(builder: (context) => HomePage());
  }
}
