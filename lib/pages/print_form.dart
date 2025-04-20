import 'package:flutter/material.dart';
import 'package:label_printer/models/company.dart';

class PrintFormPage extends StatelessWidget {
  final Company company;

  const PrintFormPage({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        debugPrint('touched');
        // This is used to dismiss the keyboard when tapping outside of a text field
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: true,
        appBar: AppBar(title: Text('Print')),
        body: SafeArea(
          child: Column(children: [Expanded(child: _PrintForm(key: ValueKey(company.name), company: company))]),
        ),
      ),
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
  final _formKey = GlobalKey<FormState>();

  String _quantityType = 'Weight';
  String? _selectedUnit = 'g';

  final TextEditingController _productName = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  final TextEditingController _mrp = TextEditingController();

  final FocusNode _productNameFocus = FocusNode();
  final FocusNode _quantityFocus = FocusNode();
  final FocusNode _mrpFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Product Name
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text('Product Name', style: Theme.of(context).textTheme.labelLarge),
                  TextFormField(
                    focusNode: _productNameFocus,
                    onChanged: (value) => setState(() {}),
                    decoration: InputDecoration(
                      suffixIcon:
                          _productNameFocus.hasFocus && _productName.text.isNotEmpty
                              ? IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  _productName.clear();
                                },
                              )
                              : null,
                    ),
                    controller: _productName,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                spacing: 10,
                children: [
                  Text('Quantity Type', style: Theme.of(context).textTheme.labelLarge),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _quantityType,
                      items: [
                        DropdownMenuItem<String>(value: 'Weight', child: Text('Weight')),
                        DropdownMenuItem<String>(value: 'Count', child: Text('Count')),
                        DropdownMenuItem<String>(value: 'None', child: Text('None')),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _quantityType = val as String;
                          if (val == 'None') {
                            _quantity.clear();
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Quantity
            if (_quantityType != 'None')
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text(_quantityType, style: Theme.of(context).textTheme.labelLarge),
                    TextFormField(
                      focusNode: _quantityFocus,
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        enabled: _quantityType != 'None',
                        suffixIcon:
                            _quantityType == 'Weight'
                                ? Row(
                                  mainAxisSize: MainAxisSize.min, // Ensures the row takes minimal space
                                  children: [
                                    DropdownButton<String>(
                                      value: _selectedUnit,
                                      isDense: true,
                                      underline: const SizedBox(), // Removes the default underline
                                      items: const [
                                        DropdownMenuItem(value: 'g', child: Text('gram (g)')),
                                        DropdownMenuItem(value: 'kg', child: Text('kilogram (kg)')),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedUnit = value; // Update the selected unit
                                        });
                                      },
                                    ),
                                  ],
                                )
                                : null,
                      ),
                      controller: _quantity,
                    ),
                  ],
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text('MRP.', style: Theme.of(context).textTheme.labelLarge),
                  TextFormField(
                    focusNode: _mrpFocus,
                    onChanged: (value) => setState(() {}),
                    decoration: InputDecoration(
                      prefixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                            child: Text('₹', style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 18)),
                          ),
                        ],
                      ),
                    ),
                    controller: _mrp,
                  ),
                ],
              ),
            ),

            // Horizontal Divider
            Padding(padding: const EdgeInsets.all(16.0), child: const Divider(height: 1, thickness: 1)),
          ],
        ),
      ),
    );
  }
}
