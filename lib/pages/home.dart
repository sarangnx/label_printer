import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const HomeBody());
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Label Template')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: List.filled(
          20,
          GestureDetector(
            onTap: () {
              // Handle click for Template 1
              debugPrint('Template 1 clicked');
            },
            child: Card(
              elevation: 0,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(width: 0.3)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                trailing: const Icon(Icons.arrow_circle_right),
                title: Text('Royal Foods'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
