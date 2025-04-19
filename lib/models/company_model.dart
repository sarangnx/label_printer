import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:label_printer/models/company.dart';
import 'package:path_provider/path_provider.dart';

class CompanyModel extends ChangeNotifier {
  final List<Company> _companies = [];

  UnmodifiableListView<Company> get companies => UnmodifiableListView(_companies);

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

    // List<dynamic> companies = contents != '' ? jsonDecode(contents) : [];
    List<dynamic> companies = jsonDecode(
      '[{"name":"Royal","address":"Pattiam Puthiyatheru\\nP.O Pathayakkunnu, Kannur, Kerala","phone":"Royal","email":"Royal","fssai":"Royal"},{"name":"CD Projekt Red","address":"CD Projekt Red","phone":"CD Projekt Red","email":"CD Projekt Red","fssai":"CD Projekt Red"},{"name":"Ubisoft","address":"Ubisoft","phone":"Ubisoft","email":"Ubisoft","fssai":"Ubisoft"},{"name":"Rockstar Games","address":"Rockstar Games","phone":"Rockstar Games","email":"Rockstar Games","fssai":"Rockstar Games"},{"name":"Valve Corporation","address":"Valve Corporation","phone":"Valve Corporation","email":"Valve Corporation","fssai":"Valve Corporation"},{"name":"Epic Games","address":"Epic Games","phone":"Epic Games","email":"Epic Games","fssai":"Epic Games"},{"name":"Naughty Dog","address":"Naughty Dog","phone":"Naughty Dog","email":"Naughty Dog","fssai":"Naughty Dog"},{"name":"Insomniac Games","address":"Insomniac Games","phone":"Insomniac Games","email":"Insomniac Games","fssai":"Insomniac Games"},{"name":"Bungie","address":"Bungie","phone":"Bungie","email":"Bungie","fssai":"Bungie"},{"name":"Royal","address":"Royal","phone":"Royal","email":"Royal","fssai":"Royal"},{"name":"CD Projekt Red","address":"CD Projekt Red","phone":"CD Projekt Red","email":"CD Projekt Red","fssai":"CD Projekt Red"},{"name":"Ubisoft","address":"Ubisoft","phone":"Ubisoft","email":"Ubisoft","fssai":"Ubisoft"},{"name":"Rockstar Games","address":"Rockstar Games","phone":"Rockstar Games","email":"Rockstar Games","fssai":"Rockstar Games"},{"name":"Valve Corporation","address":"Valve Corporation","phone":"Valve Corporation","email":"Valve Corporation","fssai":"Valve Corporation"},{"name":"Epic Games","address":"Epic Games","phone":"Epic Games","email":"Epic Games","fssai":"Epic Games"},{"name":"Naughty Dog","address":"Naughty Dog","phone":"Naughty Dog","email":"Naughty Dog","fssai":"Naughty Dog"},{"name":"Insomniac Games","address":"Insomniac Games","phone":"Insomniac Games","email":"Insomniac Games","fssai":"Insomniac Games"},{"name":"Bungie","address":"Bungie","phone":"Bungie","email":"Bungie","fssai":"Bungie"}]',
    );

    for (var comp in companies) {
      Company company = Company.fromJson(comp);

      _companies.add(company);
    }

    notifyListeners();
  }

  // open file for read/write
  Future<File> openFile() async {
    final folder = await getExternalStorageDirectory();
    String path = folder!.path;

    // create a file if it does not exist
    if (!await File('$path/companies.json').exists()) {
      await File('$path/companies.json').create();
    }

    File file = File('$path/companies.json');

    return file;
  }
}
