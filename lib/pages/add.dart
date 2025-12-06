import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/company.dart';
import '../models/company_model.dart';

class AddCompanyPage extends StatelessWidget {
  const AddCompanyPage({super.key});

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
        appBar: AppBar(title: Text('Add Company')),
        body: SafeArea(child: Column(children: [Expanded(child: AddCompany())])),
      ),
    );
  }
}

class AddCompany extends StatefulWidget {
  const AddCompany({super.key});

  @override
  State<AddCompany> createState() => _AddCompanyForm();
}

class _AddCompanyForm extends State<AddCompany> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _companyName = TextEditingController();
  final TextEditingController _companyAddress = TextEditingController();
  final TextEditingController _companyPhone = TextEditingController();
  final TextEditingController _companyEmail = TextEditingController();
  final TextEditingController _companyFssai = TextEditingController();
  final TextEditingController _width = TextEditingController(text: '50');
  final TextEditingController _height = TextEditingController(text: '30');
  final TextEditingController _columns = TextEditingController(text: '2');
  final TextEditingController _columnGap = TextEditingController(text: '3');
  final TextEditingController _rowGap = TextEditingController(text: '3');

  bool _reverseDirection = false;
  bool _hideCompanyDetails = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Name
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _companyName,
                decoration: const InputDecoration(labelText: 'Company Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Company name is required';
                  }
                  return null;
                },
              ),
            ),

            // Company Address
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _companyAddress,
                decoration: const InputDecoration(labelText: 'Company Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Company address is required';
                  }
                  return null;
                },
              ),
            ),

            // Company Phone
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _companyPhone,
                decoration: const InputDecoration(labelText: 'Company Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Company phone is required';
                  }
                  return null;
                },
              ),
            ),

            // Company Email
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _companyEmail,
                decoration: const InputDecoration(labelText: 'Company Email'),
                keyboardType: TextInputType.emailAddress,
              ),
            ),

            // Company FSSAI
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _companyFssai,
                decoration: const InputDecoration(labelText: 'Company FSSAI'),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Divider(thickness: 1.5),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Label Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _width,
                      decoration: const InputDecoration(labelText: 'Label Width (mm)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _height,
                      decoration: const InputDecoration(labelText: 'Label Height (mm)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _columnGap,
                      decoration: const InputDecoration(labelText: 'Column Gap (mm)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _rowGap,
                      decoration: const InputDecoration(labelText: 'Row Gap (mm)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _columns,
                      decoration: const InputDecoration(labelText: 'Number of labels in a row'),
                      keyboardType: TextInputType.number,
                    ),
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
                    value: _reverseDirection,
                    onChanged: (value) {
                      setState(() {
                        _reverseDirection = value;
                      });
                    },
                  ),
                  Text('Reverse Print Direction'),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                spacing: 8,
                children: [
                  Switch(
                    value: _hideCompanyDetails,
                    onChanged: (value) {
                      setState(() {
                        _hideCompanyDetails = value;
                      });
                    },
                  ),
                  Text('Hide company details on label'),
                ],
              ),
            ),

            // Submit Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Expanded(
                child: FilledButton(
                  style: Theme.of(context).filledButtonTheme.style!.copyWith(
                    padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 16)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Collect data and handle submission
                      final companyData = {
                        'name': _companyName.text,
                        'address': _companyAddress.text,
                        'phone': _companyPhone.text,
                        'email': _companyEmail.text,
                        'fssai': _companyFssai.text,
                        'width': int.tryParse(_width.text) ?? 50,
                        'height': int.tryParse(_height.text) ?? 30,
                        'columns': int.tryParse(_columns.text) ?? 2,
                        'columnGap': int.tryParse(_columnGap.text) ?? 3,
                        'rowGap': int.tryParse(_rowGap.text) ?? 3,
                        'reverseDirection': _reverseDirection,
                        'hideCompanyDetails': _hideCompanyDetails,
                      };

                      var company = Company.fromJson(companyData);

                      Provider.of<CompanyModel>(context, listen: false).add(company);

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Company added successfully!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );

                      // Clear the form
                      _formKey.currentState!.reset();
                      _companyName.clear();
                      _companyAddress.clear();
                      _companyPhone.clear();
                      _companyEmail.clear();
                      _companyFssai.clear();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [const Text('Add Company', style: TextStyle(fontSize: 16)), Icon(Icons.save, size: 20)],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
