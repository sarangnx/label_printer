import 'package:flutter/material.dart';

import 'package:label_printer/models/company.dart';

class UserInput extends StatelessWidget {
  final Company company;

  UserInput({Key key, this.company}) : super(key: key);

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
          'Print',
          style: TextStyle(color: Color(0xFFF5855A)),
        ),
      ),
      body: _InputForm(),
    );
  }
}

class _InputForm extends StatefulWidget {
  _InputForm({Key key}) : super(key: key);

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<_InputForm> {
  final _formKey = GlobalKey<FormState>();

  String quantityType = 'Weight';
  String dateType = 'Date';

  /// Create InputDecoration for form fields
  ///
  /// Takes [labelText] and creates InputDecoration for a form field
  InputDecoration decoration() {
    return InputDecoration(
      border: UnderlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                  Row(
                    children: [
                      Flexible(
                        child: DropdownButtonFormField(
                          decoration: decoration(),
                          value: quantityType,
                          items: [
                            DropdownMenuItem(
                              child: Text('Weight'),
                              value: 'Weight',
                            ),
                            DropdownMenuItem(
                              child: Text('Count'),
                              value: 'Count',
                            )
                          ],
                          onChanged: (val) {
                            setState(() {
                              quantityType = val;
                            });
                          },
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: TextFormField(
                            cursorColor: Color(0xFFF5855A),
                            decoration: decoration(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.transparent, height: 40),
                  Row(
                    children: [
                      Flexible(
                        child: DropdownButtonFormField(
                          decoration: decoration(),
                          value: dateType,
                          items: [
                            DropdownMenuItem(
                              child: Text('Date'),
                              value: 'Date',
                            ),
                            DropdownMenuItem(
                              child: Text('Expiry Date'),
                              value: 'Expiry Date',
                            )
                          ],
                          onChanged: (val) {
                            setState(() {
                              dateType = val;
                            });
                          },
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: TextFormField(
                            cursorColor: Color(0xFFF5855A),
                            decoration: decoration(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.green,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        'Print',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Icon(Icons.print),
                  ],
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
