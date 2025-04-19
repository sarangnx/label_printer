import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/company_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CompanyModel model = CompanyModel();

  @override
  void initState() {
    super.initState();
    Provider.of<CompanyModel>(context, listen: false).loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Select Label Template')), body: const HomeBody());
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<CompanyModel>(
        builder: (context, model, child) {
          if (model.companies.isEmpty) return EmptyPage();

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: model.companies.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  elevation: 0.1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(width: 0.1),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/print', arguments: model.companies[index]);
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      leading: CircleAvatar(
                        radius: 20, // Size of the avatar
                        child: Text(model.companies[index].name[0]), // Display initials or text
                      ),
                      // trailing: const Icon(Icons.arrow_circle_right),
                      title: Text(model.companies[index].name),
                      subtitle: Text(model.companies[index].address, overflow: TextOverflow.ellipsis, maxLines: 1),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('<empty>'));
  }
}
