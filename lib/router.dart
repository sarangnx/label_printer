import 'package:flutter/material.dart';

import 'models/company.dart';
import 'pages/add.dart';
import 'pages/home.dart';
import 'pages/print_form.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => HomePage());
    case '/print':
      var company = settings.arguments as Company;
      return MaterialPageRoute(builder: (context) => PrintFormPage(company: company));
    case '/add-company':
      return MaterialPageRoute(builder: (context) => AddCompanyPage());
    default:
      return MaterialPageRoute(builder: (context) => HomePage());
  }
}
