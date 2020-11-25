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

  final List<Map> fields = <Map>[
    {'labelText': 'Name'},
    {'labelText': 'Address', 'multiLine': true},
    {'labelText': 'Phone Number'},
    {'labelText': 'FSSAI Number'}
  ];

  @override
  _ItemFormState createState() => _ItemFormState();
}

class _ItemFormState extends State<_ItemForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
        separatorBuilder: (BuildContext context, int index) => const Divider(
          color: Colors.transparent,
          height: 40,
        ),
        itemBuilder: (BuildContext context, int index) {
          return TextField(
            cursorColor: Color(0xFFF5855A),
            decoration: InputDecoration(
              border: UnderlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
              ),
              contentPadding: EdgeInsets.fromLTRB(20, -10, 20, 10),
              labelText: widget.fields[index]['labelText'],
              labelStyle: TextStyle(
                fontSize: 20,
                color: Color(0xFFF5855A),
                fontWeight: FontWeight.bold,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              filled: true,
              fillColor: Colors.white,
            ),
            maxLines: widget.fields[index]['multiLine'] == true ? 3 : 1,
          );
        },
        itemCount: widget.fields.length,
      ),
    );
  }
}
