import 'package:flutter/material.dart';
import 'package:label_printer/pages/edit.dart';

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
    case '/edit-company':
      var args = settings.arguments as Map<String, dynamic>?;
      var index = args?['index'] as int;
      var company = args?['company'] as Company;

      return MaterialPageRoute(builder: (context) => EditCompanyPage(index: index, company: company));
    default:
      return MaterialPageRoute(builder: (context) => HomePage());
  }
}
