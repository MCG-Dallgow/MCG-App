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
          appBar: MCGAppBar(title: "Raumplan"),
          drawer: const MCGDrawer(),
          body: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: MySearchDelegate(),
                        );
                      },
                      icon: const Icon(
                        Icons.search,
                        size: 40,
                      )),
                  const Text(
                    'Search',
                    style: TextStyle(fontSize: 32),
                  ),
                ],
              ),
              Center(
                child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromRGBO(0, 0, 0, 1),
                        width: 3,
                      ),
                      color: const Color.fromRGBO(200, 200, 200, 1),
                    ),
                    width: 100,
                    height: 100,
                    child: const Center(
                      child: Text("1.60"),
                    )
                  ),
                  onTap: () { },
                ),
              ),
            ],
          ),
        floatingActionButton: SpeedDial(
          marginBottom: 10,
          icon: Icons.layers,
          activeIcon: Icons.close,
          backgroundColor: Colors.blueGrey
          foregroundColor: Colors.white,
          activeBackgroundColor: Colors.blueGrey
          activeForegroundColor: Colors.white,
          buttonSize: 56.0,
          visible: true,
          closeManually: false,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          elevation: 8.0,
          shape CircleBorder(),

          children: [
            SpeedDialChild(
              child: Icon(Icons.layers),
              backgroundColor: Colors.blueGrey
              foregroundColor: Colors.white,
              label: 'Untergeschoss',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => print('Untergeschoss'),
            ),
            SpeedDialChild(
              child: Icon(Icons.layers),
              backgroundColor: Colors.blueGrey
              foregroundColor: Colors.white,
              label: '1. Obergeschoss',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => print('1. Obergeschoss'),
            ),
            SpeedDialChild(
              child: Icon(Icons.layers),
              backgroundColor: Colors.blueGrey
              foregroundColor: Colors.white,
              label: '2. Obergeschoss',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => print('2. Obergeschoss'),
            ),
          ],
        ),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  List<String> searchResults = [
      'Raum 1.64',
      'Raum 1.65',
      'Raum 1.66',
      'Raum 1.67'
    ];

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
        child: Text(query, style: const TextStyle(fontSize: 64)),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];

        return ListTile(
          title: Text(suggestion),
          onTap: () {
            query = suggestion;

            showResults(context);
          },
        );
      },
    );
  }
}
