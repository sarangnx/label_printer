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
    return Scaffold(
      appBar: AppBar(title: const Text('Select Label Template')),
      body: const HomeBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-company');
        },
        child: const Icon(Icons.add),
      ),
    );
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
              Offset? tapPosition;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  elevation: 0.1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(width: 0.1),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/print', arguments: model.companies[index]);
                    },
                    onLongPressStart: (details) {
                      tapPosition = details.globalPosition;
                    },
                    onLongPress: () async {
                      if (tapPosition == null) return;
                      final selected = await showMenu<String>(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          tapPosition!.dx,
                          tapPosition!.dy,
                          MediaQuery.of(context).size.width - tapPosition!.dx,
                          MediaQuery.of(context).size.height - tapPosition!.dy,
                        ),
                        items: [
                          const PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
                          const PopupMenuItem<String>(value: 'delete', child: Text('Delete')),
                        ],
                      );

                      if (selected == 'edit') {
                        Navigator.pushNamed(
                          context,
                          '/edit-company',
                          arguments: {'company': model.companies[index], 'index': index},
                        );
                      } else if (selected == 'delete') {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder:
                              (ctx) => AlertDialog(
                                title: const Text('Delete Company'),
                                content: const Text('Are you sure you want to delete this company?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete')),
                                ],
                              ),
                        );
                        if (confirm == true) {
                          model.delete(index);
                        }
                      }
                    },
                    child: InkWell(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        leading: CircleAvatar(radius: 20, child: Text(model.companies[index].columns.toString())),
                        title: Row(
                          textBaseline: TextBaseline.alphabetic,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          spacing: 10,
                          children: [
                            Text(
                              model.companies[index].name,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '(${model.companies[index].width}x${model.companies[index].height} mm)',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        subtitle: Text(model.companies[index].address, overflow: TextOverflow.ellipsis, maxLines: 1),
                      ),
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
