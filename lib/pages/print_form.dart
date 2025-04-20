import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:label_printer/models/company.dart';

class PrintFormPage extends StatelessWidget {
  final Company company;

  const PrintFormPage({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

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

enum QuantityTypes { weight, count, none }

class PrinterForm extends State<_PrintForm> {
  final _formKey = GlobalKey<FormState>();

  QuantityTypes _quantityType = QuantityTypes.weight;
  String? _selectedUnit = 'g';
  DateTime? _mfgDateTime = DateTime.now();
  DateTime? _expiryDateTime = DateTime.now().add(Duration(days: 45));
  bool _showExpiryDate = false;

  final TextEditingController _productName = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  final TextEditingController _mrp = TextEditingController();
  final TextEditingController _mfgDate = TextEditingController();
  final TextEditingController _expiryDate = TextEditingController();

  final FocusNode _productNameFocus = FocusNode();
  final FocusNode _mrpFocus = FocusNode();

  // Date picker for first date field
  Future<void> _selectMfgDate(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _mfgDateTime ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _mfgDateTime = picked;
        _mfgDate.value = TextEditingValue(text: DateFormat('d MMMM y').format(picked));
      });
    }
  }

  Future<void> _selectExpiryDate(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _expiryDateTime ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _expiryDateTime = picked;
        _expiryDate.value = TextEditingValue(text: DateFormat('d MMMM y').format(picked));
      });
    }
  }

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
              child: SizedBox(
                width: double.infinity, // Makes the SegmentedButton take full width
                child: SegmentedButton<QuantityTypes>(
                  multiSelectionEnabled: false,
                  segments: const [
                    ButtonSegment(value: QuantityTypes.weight, label: Text('Weight')),
                    ButtonSegment(value: QuantityTypes.count, label: Text('Count')),
                    ButtonSegment(value: QuantityTypes.none, label: Text('None')),
                  ],
                  selected: {_quantityType},
                  onSelectionChanged: (Set<QuantityTypes> newSelection) {
                    setState(() {
                      _quantityType = newSelection.first;
                    });
                  },
                ),
              ),
            ),

            // Quantity
            if (_quantityType != QuantityTypes.none)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text(
                      _quantityType == QuantityTypes.weight ? 'Weight' : 'Count',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    TextFormField(
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        enabled: _quantityType != QuantityTypes.none,
                        suffixIcon:
                            _quantityType == QuantityTypes.weight
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
                  Text('MRP', style: Theme.of(context).textTheme.labelLarge),
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
                      suffixIcon:
                          _mrpFocus.hasFocus && _mrp.text.isNotEmpty
                              ? IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  _mrp.clear();
                                },
                              )
                              : null,
                    ),
                    controller: _mrp,
                  ),
                ],
              ),
            ),

            // Horizontal Divider
            Padding(padding: const EdgeInsets.all(16.0), child: const Divider(height: 1, thickness: 1)),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 8,
                children: [Text('Dates', style: Theme.of(context).textTheme.titleMedium)],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text('MFG Date', style: Theme.of(context).textTheme.labelLarge),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _selectMfgDate(context);
                          },
                          child: AbsorbPointer(
                            child: TextFormField(onChanged: (value) => setState(() {}), controller: _mfgDate),
                          ),
                        ),
                      ),
                      if (_mfgDate.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _mfgDate.clear(); // Clear the date
                              _mfgDateTime = null; // Reset the selected date
                            });
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                spacing: 8,
                children: [
                  Switch(
                    value: _showExpiryDate,
                    onChanged: (value) {
                      setState(() {
                        _showExpiryDate = value;
                      });
                    },
                  ),
                  Text('Show expiry date'),
                ],
              ),
            ),

            if (_showExpiryDate)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text('Expiry Date', style: Theme.of(context).textTheme.labelLarge),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _selectExpiryDate(context);
                            },
                            child: AbsorbPointer(
                              child: TextFormField(onChanged: (value) => setState(() {}), controller: _expiryDate),
                            ),
                          ),
                        ),
                        if (_expiryDate.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _expiryDate.clear(); // Clear the date
                                _expiryDateTime = null; // Reset the selected date
                              });
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),

            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: FilledButton(
                      style: Theme.of(context).filledButtonTheme.style!.copyWith(
                        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 16)),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Handle the print action here
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 10,
                        children: [
                          const Text('Print Label', style: TextStyle(fontSize: 16)),
                          Icon(Icons.print, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
