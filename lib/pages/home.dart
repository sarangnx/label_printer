import 'package:flutter/material.dart';
import 'add.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF2ED),
      body: SafeArea(
        top: true,
        child: Center(
          child: Text(
            'Home',
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItem()),
          );
        },
        child: Icon(Icons.add),
        elevation: 2.0,
        backgroundColor: Color(0xFFF5855A),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: Icon(Icons.home),
                  color: Color(0xFFF5855A),
                  onPressed: () {}),
              IconButton(
                  icon: Icon(Icons.folder),
                  color: Color(0xFFF5855A),
                  onPressed: () {})
            ],
          ),
        ),
        shape: CircularNotchedRectangle(),
      ),
    );
  }
}
