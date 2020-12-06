import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:label_printer/models/company.dart';

class CompanyModel extends ChangeNotifier {
  final List<Company> _companies = [];

  UnmodifiableListView<Company> get companies =>
      UnmodifiableListView(_companies);

  /// add a new company to list
  void add(Company company) async {
    _companies.add(company);

    File file = await openFile();
    String contents = await file.readAsString();

    List<dynamic> companies = contents != '' ? jsonDecode(contents) : [];

    Map<String, dynamic> item = company.toJson();
    companies.add(item);

    contents = jsonEncode(companies);
    await file.writeAsString(contents);

    notifyListeners();
  }

  /// load data from localstorage
  void loadData() async {
    File file = await openFile();
    String contents = await file.readAsString();

    List<dynamic> companies = contents != '' ? jsonDecode(contents) : [];

    for (var comp in companies) {
      Company company = Company.fromJson(comp);

      _companies.add(company);
    }

    notifyListeners();
  }

  // open file for read/write
  Future<File> openFile() async {
    final folder = await getExternalStorageDirectory();
    String path = folder.path;

    if (!await File('$path/companies.json').exists()) {
      await File('$path/companies.json').create();
    }

    File file = File('$path/companies.json');

    return file;
  }
}
