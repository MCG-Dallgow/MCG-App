import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';

class RoomPlan extends StatelessWidget {
  const RoomPlan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: MCGAppBar(title: "MCG App"),
        drawer: const MCGDrawer(),
        body: Column(
          children: <Widget> [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(32.0, 32.0, 32.0, 24.0),
              child: Row(children: <Widget> [
                IconButton(onPressed: () {
                  showSearch(context: context,
                      delegate: MySearchDelegate());
                }, icon: const Icon(Icons.search, size: 40,)),
                const Text('  Search', style: const TextStyle(fontSize: 32),),
              ],)
            )
          ],
        )
        ),
      );
  }
}

class MySearchDelegate extends SearchDelegate {
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        if (query.isEmpty) {
          close(context, null);
        } else {
          query = '';
        }
      },
    ),
  ];

  @override
  Widget buildResults(BuildContext context) => Center(
    child: Text(
      query,
      style: const TextStyle(fontSize: 64)
    ),
  );

  @override
  Widget buildSuggestions(BuildContext context) {
    List <String> suggestions = [
      'Raum 1.64',
      'Raum 1.65',
      'Raum 1.66',
      'Raum 1.67'
    ];

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];

        return ListTile(
          title: Text(suggestion),
          onTap:() {
            query = suggestion;

            showResults(context);
          },
        );
        },
    );
  }
}
