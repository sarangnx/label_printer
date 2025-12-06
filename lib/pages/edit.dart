import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/company.dart';
import '../models/company_model.dart';

class EditCompanyPage extends StatelessWidget {
  final Company company;
  final int index;
  const EditCompanyPage({super.key, required this.company, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Company')),
        body: SafeArea(child: Column(children: [Expanded(child: EditCompanyForm(company: company, index: index))])),
      ),
    );
  }
}

class EditCompanyForm extends StatefulWidget {
  final Company company;
  final int index;
  const EditCompanyForm({super.key, required this.company, required this.index});

  @override
  State<EditCompanyForm> createState() => _EditCompanyFormState();
}

class _EditCompanyFormState extends State<EditCompanyForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _companyName;
  late TextEditingController _companyAddress;
  late TextEditingController _companyPhone;
  late TextEditingController _companyEmail;
  late TextEditingController _companyFssai;
  late TextEditingController _width;
  late TextEditingController _height;
  late TextEditingController _columns;
  late TextEditingController _columnGap;
  late TextEditingController _rowGap;
  late TextEditingController _marginTop;
  late TextEditingController _marginLeft;

  late bool _reverseDirection;
  late bool _hideCompanyDetails;

  @override
  void initState() {
    super.initState();
    final c = widget.company;
    _companyName = TextEditingController(text: c.name);
    _companyAddress = TextEditingController(text: c.address);
    _companyPhone = TextEditingController(text: c.phone);
    _companyEmail = TextEditingController(text: c.email);
    _companyFssai = TextEditingController(text: c.fssai);
    _width = TextEditingController(text: c.width.toString());
    _height = TextEditingController(text: c.height.toString());
    _columns = TextEditingController(text: c.columns.toString());
    _columnGap = TextEditingController(text: c.columnGap.toString());
    _rowGap = TextEditingController(text: c.rowGap.toString());
    _marginTop = TextEditingController(text: c.marginTop.toString());
    _marginLeft = TextEditingController(text: c.marginLeft.toString());
    _reverseDirection = c.reverseDirection;
    _hideCompanyDetails = c.hideCompanyDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ...existing code from AddCompanyForm, but using the above controllers and bools...
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _companyEmail,
                decoration: const InputDecoration(labelText: 'Company Email'),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
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
                      controller: _marginTop,
                      decoration: const InputDecoration(labelText: 'Margin Top (mm)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _marginLeft,
                      decoration: const InputDecoration(labelText: 'Margin Left (mm)'),
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
                children: [
                  Switch(
                    value: _reverseDirection,
                    onChanged: (value) {
                      setState(() {
                        _reverseDirection = value;
                      });
                    },
                  ),
                  const Text('Reverse Print Direction'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Switch(
                    value: _hideCompanyDetails,
                    onChanged: (value) {
                      setState(() {
                        _hideCompanyDetails = value;
                      });
                    },
                  ),
                  const Text('Hide company details on label'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FilledButton(
                style: Theme.of(context).filledButtonTheme.style!.copyWith(
                  padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 16)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
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
                      'marginTop': int.tryParse(_marginTop.text) ?? 2,
                      'marginLeft': int.tryParse(_marginLeft.text) ?? 5,
                      'reverseDirection': _reverseDirection,
                      'hideCompanyDetails': _hideCompanyDetails,
                    };
                    var updatedCompany = Company.fromJson(companyData);
                    // ignore: use_build_context_synchronously
                    Provider.of<CompanyModel>(context, listen: false).update(widget.index, updatedCompany);
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Company updated successfully!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Text('Save Changes', style: TextStyle(fontSize: 16)), Icon(Icons.save, size: 20)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
