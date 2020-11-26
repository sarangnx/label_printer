import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:label_printer/models/company.dart';

class AddItem extends StatelessWidget {
  AddItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFFFF2ED),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Color(0xFFF5855A),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Add New Label',
          style: TextStyle(color: Color(0xFFF5855A)),
        ),
      ),
      body: _ItemForm(),
    );
  }
}

class _ItemForm extends StatefulWidget {
  _ItemForm({Key key}) : super(key: key);

  @override
  _ItemFormState createState() => _ItemFormState();
}

class _ItemFormState extends State<_ItemForm> {
  final _formKey = GlobalKey<FormState>();
  Company _company = new Company();

  /// Create InputDecoration for form fields
  ///
  /// Takes [labelText] and creates InputDecoration for a form field
  InputDecoration decoration(String labelText) {
    return InputDecoration(
      border: UnderlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(20, -10, 20, 10),
      labelText: labelText,
      labelStyle: TextStyle(
        fontSize: 20,
        color: Color(0xFFF5855A),
        fontWeight: FontWeight.bold,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // https://flutterigniter.com/dismiss-keyboard-form-lose-focus/
        // used to dismiss keyboard and focus on clicking outside of text field
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                children: [
                  TextFormField(
                      cursorColor: Color(0xFFF5855A),
                      decoration: decoration('Name'),
                      validator: (val) => val.isEmpty ? 'Name Required' : null,
                      onSaved: (val) => _company.name = val),
                  Divider(color: Colors.transparent, height: 40),
                  TextFormField(
                      cursorColor: Color(0xFFF5855A),
                      decoration: decoration('Address'),
                      maxLines: 3,
                      onSaved: (val) => _company.address = val),
                  Divider(color: Colors.transparent, height: 40),
                  TextFormField(
                      cursorColor: Color(0xFFF5855A),
                      decoration: decoration('Phone Number'),
                      onSaved: (val) => _company.phone = val),
                  Divider(color: Colors.transparent, height: 40),
                  TextFormField(
                      cursorColor: Color(0xFFF5855A),
                      decoration: decoration('FSSAI Number'),
                      onSaved: (val) => _company.fssai = val),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: ElevatedButton(
                child: Icon(Icons.save),
                onPressed: _addItem,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _addItem() async {
    final FormState form = _formKey.currentState;

    if (!form.validate()) return;

    // invoke onSave on all form elements
    form.save();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> items = prefs.getStringList('companies') ?? <String>[];

    // encode item to string, add it to item list and save to shared preferences
    String item = jsonEncode(_company);
    items.add(item);
    prefs.setStringList('companies', items);

    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text('Added Label')),
    );
  }
}
