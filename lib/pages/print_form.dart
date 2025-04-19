import 'package:flutter/material.dart';
import 'package:label_printer/models/company.dart';

class PrintFormPage extends StatelessWidget {
  final Company company;

  const PrintFormPage({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text('Print', style: TextStyle(color: Color(0xFFF5855A)))),
      body: _PrintForm(key: ValueKey(company.name), company: company),
    );
  }
}

class _PrintForm extends StatefulWidget {
  const _PrintForm({super.key, required this.company});

  final Company company;

  @override
  State<_PrintForm> createState() => PrinterForm();
}

class PrinterForm extends State<_PrintForm> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Simple Text Widget', style: TextStyle(fontSize: 20, color: Colors.black)));
  }
}
