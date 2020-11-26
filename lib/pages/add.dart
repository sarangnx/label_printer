import 'package:flutter/material.dart';

class AddItem extends StatelessWidget {
  AddItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        key: _formKey,
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
          children: [
            TextFormField(
              cursorColor: Color(0xFFF5855A),
              decoration: decoration('Name'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Name Required';
                }
                return null;
              },
            ),
            Divider(color: Colors.transparent, height: 40),
            TextFormField(
              cursorColor: Color(0xFFF5855A),
              decoration: decoration('Address'),
              maxLines: 3,
            ),
            Divider(color: Colors.transparent, height: 40),
            TextFormField(
              cursorColor: Color(0xFFF5855A),
              decoration: decoration('Phone Number'),
            ),
            Divider(color: Colors.transparent, height: 40),
            TextFormField(
              cursorColor: Color(0xFFF5855A),
              decoration: decoration('FSSAI Number'),
            ),
            Divider(color: Colors.transparent, height: 40),
            ElevatedButton(
              child: Icon(Icons.save),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Added Label')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
