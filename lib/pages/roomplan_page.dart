import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
        appBar: MCGAppBar(
          title: "Raumplan",
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: MySearchDelegate(),
                );
              },
            ),
          ],
        ),
        drawer: const MCGDrawer(),
        body: Column(
          children: <Widget>[
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
                    )),
                onTap: () {},
              ),
            ),
          ],
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.layers,
          activeIcon: Icons.close,
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
          activeBackgroundColor: Colors.blueGrey,
          activeForegroundColor: Colors.white,
          buttonSize: const Size(56.0, 56.0),
          visible: true,
          closeManually: false,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          elevation: 8.0,
          shape: const CircleBorder(),
          children: [
            SpeedDialChild(
              child: const Text(
                "U",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
              label: 'Untergeschoss',
              labelStyle: const TextStyle(fontSize: 18.0),
              onTap: () {  },
            ),
            SpeedDialChild(
              child: const Text(
                "0",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
              label: 'Erdgeschoss',
              labelStyle: const TextStyle(fontSize: 18.0),
              onTap: () {  },
            ),
            SpeedDialChild(
              child: const Text(
                "1",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
              label: '1. Obergeschoss',
              labelStyle: const TextStyle(fontSize: 18.0),
              onTap: () {  },
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
