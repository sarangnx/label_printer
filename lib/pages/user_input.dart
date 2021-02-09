import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:label_printer/models/company.dart';
import 'package:label_printer/api/printer.dart';

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
      body: _InputForm(company: company),
    );
  }
}

class _InputForm extends StatefulWidget {
  _InputForm({Key key, this.company}) : super(key: key);

  final Company company;

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<_InputForm> {
  final _formKey = GlobalKey<FormState>();
  Printer _printer = Printer();

  String quantityType = 'Weight';
  String dateType = 'Date';
  DateTime dateTime;
  bool _showDate = true;
  // for showing second date
  bool _showSecondDate = false;
  bool _showBestBefore = false;

  TextEditingController _date = new TextEditingController();
  TextEditingController _date2 = new TextEditingController();
  TextEditingController _quantity = new TextEditingController();
  TextEditingController _mrp = new TextEditingController();
  TextEditingController _copies = new TextEditingController();
  TextEditingController _bestBefore = new TextEditingController(text: '45 days');

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

  // Date picker for first date field
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null)
      setState(() {
        dateTime = picked;
        _date.value = TextEditingValue(
          text: DateFormat(_showDate ? 'd MMMM y' : 'MMMM y').format(picked),
        );
      });
  }

  // Date picker for second date
  Future<void> _selectDate2(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null)
      setState(() {
        _date2.value = TextEditingValue(
          text: DateFormat('d MMMM y').format(picked),
        );
      });
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
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
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
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: TextFormField(
                            cursorColor: Color(0xFFF5855A),
                            decoration: decoration(),
                            controller: _quantity,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.transparent, height: 40),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            // decoration: decoration(),
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
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: _date,
                                cursorColor: Color(0xFFF5855A),
                                decoration: decoration(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      FlatButton(
                        color: Colors.orange,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        minWidth: 55,
                        child: Icon(
                          _showDate ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _showDate = !_showDate;

                            // change date controller value
                            if (dateTime != null) {
                              _date.value = TextEditingValue(
                                text: DateFormat(
                                  _showDate ? 'd MMMM y' : 'MMMM y',
                                ).format(dateTime),
                              );
                            }
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.transparent, height: 40),
                  Row(
                    children: [
                      Checkbox(
                        value: _showSecondDate,
                        onChanged: (value) {
                          setState(() {
                            _showSecondDate = value;
                          });
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Show secondary date',
                          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.transparent, height: 40),
                  if (_showSecondDate) ...[
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Expiry Date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () {
                                _selectDate2(context);
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _date2,
                                  cursorColor: Color(0xFFF5855A),
                                  decoration: decoration(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(color: Colors.transparent, height: 40)
                  ],
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'MRP',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: TextFormField(
                            controller: _mrp,
                            cursorColor: Color(0xFFF5855A),
                            decoration: decoration(),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.transparent, height: 40),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Copies',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: TextFormField(
                            controller: _copies,
                            cursorColor: Color(0xFFF5855A),
                            decoration: decoration(),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.transparent, height: 40),
                  Row(
                    children: [
                      Checkbox(
                        value: _showBestBefore,
                        onChanged: (value) {
                          setState(() {
                            _showBestBefore = value;
                          });
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Show Best Before',
                          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  if (_showBestBefore)
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Best Before',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: TextFormField(
                              controller: _bestBefore,
                              cursorColor: Color(0xFFF5855A),
                              decoration: decoration(),
                              keyboardType: TextInputType.text,
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
                onPressed: () async {
                  Map<String, dynamic> data = {
                    'quantityType': quantityType,
                    'quantity': _quantity.text,
                    'dateType': dateType,
                    'date': _date.text,
                    'showDate2': _showSecondDate,
                    'date2': _date2.text,
                    'mrp': _mrp.text,
                    'copies': _copies.text,
                    'name': widget.company.name,
                    'address': widget.company.address,
                    'fssai': widget.company.fssai,
                    'phone': widget.company.phone,
                    'bestBefore': _showBestBefore ? _bestBefore.text : null
                  };

                  await _printer.init();
                  await _printer.printLabel(data);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
