import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add.dart';
import 'package:label_printer/models/company_model.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CompanyModel model = CompanyModel();

  @override
  void initState() {
    model.loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF2ED),
      body: HomeBody(),
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

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Consumer<CompanyModel>(
        builder: (context, model, child) => ListView.builder(
          itemCount: model.companies.length,
          itemBuilder: (context, index) {
            return Card(
              child: Text('${model.companies[index].name}'),
            );
          },
        ),
      ),
    );
  }
}
