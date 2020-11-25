import 'package:flutter/material.dart';

class AddItem extends StatefulWidget {
  AddItem({Key key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
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
            }),
      ),
      body: SafeArea(
        top: true,
        child: Center(
          child: Text(
            'Add Item',
          ),
        ),
      ),
    );
  }
}
