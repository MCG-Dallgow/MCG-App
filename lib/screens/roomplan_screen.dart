import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mcgapp/theme/theme_constants.dart';

import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';

class RoomPlan extends StatefulWidget {
  const RoomPlan({Key? key}) : super(key: key);

  @override
  State<RoomPlan> createState() => _RoomPlanState();
}

class _RoomPlanState extends State<RoomPlan> {
  List<String> _rooms = [];
  int number_art = 11;

  String art = "";

  Future<String> loadJsonData() async {
    var jsonText = await rootBundle.loadString("assets/rooms.json");
    setState(() {
      var data = json.decode(jsonText);
      List test = [];
      test.addAll(data['raeume']);
      for (int i = 0; i < test.length; i++) {
        //print(test[i]);
        var test2 = data['raeume'][i]['Raeume'];
        for (int j = 0; j < test2.length; j++) {
          print(test2[j]['Raumnummer']);
          _rooms.add(test2[j]['Raumnummer']);
        }
      }
      /*_rooms.add(json.decode(jsonText)['raeume'][0]['Raeume'][0]['Raumnummer']);
      print(_rooms[0]);*/
    });
    return "success";
  }

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  /*Widget currentPage = null;
  Widget OG;
  Widget EG;*/
  Widget test = Container(
      height: 1000,
      width: 1000,
      color: Colors.red,
      child: Container(
        color: Colors.grey,
        height: 200,
        width: 200,
        child: Stack(
          children: [
            SvgPicture.asset(
              'assets/roomplan_0.svg',
              height: 100,
              color: Colors.black,
            ),
            Positioned(
              left: 50,
              right: 50,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("hi"),
              ),
            )
          ],
        ),
      ));
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: MCGAppBar(
          title: 'Raumplan',
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: MySearchDelegate(searchResults: _rooms),
                );
              },
            ),
          ],
        ),
        drawer: const MCGDrawer(),
        body: InteractiveViewer(
          maxScale: 100,
          //boundaryMargin: EdgeInsets.all(20),
          child: test,
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.layers,
          activeIcon: Icons.close,
          foregroundColor: Colors.white,
          activeForegroundColor: Colors.white,
          buttonSize: const Size(56.0, 56.0),
          visible: true,
          closeManually: false,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          elevation: 8.0,
          childMargin: const EdgeInsets.all(20.0),
          shape: const CircleBorder(),
          children: [
            SpeedDialChild(
              child: const Text(
                "U",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              backgroundColor: colorAccent,
              foregroundColor: Colors.white,
              label: "Untergeschoss",
              labelStyle: const TextStyle(fontSize: 18.0),
              onTap: () {
                setState(() {
                  test = const Text("hi");
                });
              },
            ),
            SpeedDialChild(
              child: const Text(
                "0",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              backgroundColor: colorAccent,
              foregroundColor: Colors.white,
              label: "Erdgeschoss",
              labelStyle: const TextStyle(fontSize: 18.0),
              onTap: () {},
            ),
            SpeedDialChild(
              child: const Text(
                "1",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              backgroundColor: colorAccent,
              foregroundColor: Colors.white,
              label: "1. Obergeschoss",
              labelStyle: const TextStyle(fontSize: 18.0),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  MySearchDelegate({Key? key, required this.searchResults});
  final List<String> searchResults;

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
