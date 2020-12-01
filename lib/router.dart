import 'package:flutter/material.dart';

import 'package:label_printer/pages/home.dart';
import 'package:label_printer/pages/add.dart';
import 'package:label_printer/pages/user_input.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => HomePage());
    case '/add':
      return MaterialPageRoute(builder: (context) => AddItem());
    case '/input':
      var company = settings.arguments;
      return MaterialPageRoute(
        builder: (context) => UserInput(
          company: company,
        ),
      );
    default:
      return MaterialPageRoute(builder: (context) => HomePage());
  }
}
