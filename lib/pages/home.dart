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
          Navigator.pushNamed(context, '/add');
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
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Select a template',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF5855A),
              ),
            ),
            Divider(color: Colors.transparent, height: 50),
            Consumer<CompanyModel>(
              builder: (context, model, child) => model.companies.length > 0
                  ? CompanyList(model: model)
                  : EmptyPage(),
            ),
          ],
        ),
      ),
    );
  }
}

class CompanyList extends StatelessWidget {
  CompanyList({this.model});

  final CompanyModel model;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: model.companies.length,
      itemBuilder: (context, index) {
        return Card(
          color: Color(0xFFF5855A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          child: InkWell(
            onTap: () {},
            child: ListTile(
              title: Text(
                '${model.companies[index].name}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class EmptyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('<empty>'),
    );
  }
}
