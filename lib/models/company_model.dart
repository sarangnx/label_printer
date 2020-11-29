import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:collection';
import 'dart:convert';

import 'package:label_printer/models/company.dart';

class CompanyModel extends ChangeNotifier {
  final List<Company> _companies = [];

  UnmodifiableListView<Company> get companies =>
      UnmodifiableListView(_companies);

  /// add a new company to list
  void add(Company company) async {
    _companies.add(company);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> items = prefs.getStringList('companies') ?? <String>[];

    // encode item to string, add it to item list and save to shared preferences
    String item = jsonEncode(company);
    items.add(item);
    await prefs.setStringList('companies', items);

    notifyListeners();
  }

  /// load data from localstorage
  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> companies = prefs.getStringList('companies') ?? <String>[];

    for (var companyString in companies) {
      Map<String, dynamic> companyJSON = jsonDecode(companyString);
      Company company = Company.fromJson(companyJSON);

      _companies.add(company);
    }

    notifyListeners();
  }
}
