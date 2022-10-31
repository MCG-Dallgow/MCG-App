import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mcgapp/classes/room.dart';
import 'package:mcgapp/main.dart';

import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';

class RoomplanScreen extends StatefulWidget {
  const RoomplanScreen({Key? key}) : super(key: key);

  @override
  State<RoomplanScreen> createState() => _RoomplanScreenState();
}

class _RoomplanScreenState extends State<RoomplanScreen> {
  final List<List<Room>> _rooms = [[], []];
  Widget _selectedPlan = const Center(child: Text("Wird geladen..."));
  int _currentFloor = 0;
  String appBarTitle = "Raumplan";

  late double screenWidth;
  late double screenHeight;
  late double offsetX;
  late double offsetY;
  late double planWidth;
  late double planHeight;

  Future<void> loadJsonData() async {
    var jsonText = await rootBundle.loadString("assets/data/rooms.json");

    setState(() {
      List data = json.decode(jsonText)['rooms'];
      for (int i = 0; i < data.length; i++) {
        Room room = Room.fromJson(data, i);

        if (room.number.startsWith('0')) {
          _rooms[0].add(room);
        } else if (room.number.startsWith('1')) {
          _rooms[1].add(room);
        }
      }
    });

    _setSelectedPlan(_loadPlan(0), 0);
  }

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Widget _loadPlan(int floor) => Stack(
        alignment: Alignment.topLeft,
        children: [
          Positioned(
            height: planHeight,
            width: planWidth,
            left: offsetX,
            top: offsetY,
            child: SvgPicture.asset(
              fit: BoxFit.fill,
              'assets/images/roomplan$floor-${themeManager.themeMode == ThemeMode.dark ? 'dark' : 'light'}.svg',
              width: 300,
              height: 125,
            ),
          ),
        ],
      );

  void _setSelectedPlan(Widget plan, int floor) {
    setState(() {
      _selectedPlan = plan;
      _currentFloor = floor;

      if (floor == 0) {
        appBarTitle = "Raumplan - Erdgeschoss";
      } else if (floor == 1) {
        appBarTitle = "Raumplan - Obergeschoss";
      }
    });
  }

  void _showBottomSheet(context, Room room) {
    showModalBottomSheet<dynamic>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10, top: 10),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                  color: Colors.black,
                  alignment: Alignment.topRight,
                ),
              ),
            ),
            const Divider(),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 5),
                child: Text(
                  room.name,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_tree),
              title: Text(room.type),
            ),
            ListTile(
              leading: const Icon(Icons.numbers),
              title: Text(room.number),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(room.teacher),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: MCGAppBar(
          title: appBarTitle,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                List<String> rooms = [];
                rooms.addAll(_rooms[0].map((e) => e.number));
                rooms.addAll(_rooms[1].map((e) => e.number));
                showSearch(
                  context: context,
                  delegate: MySearchDelegate(searchResults: rooms),
                );
              },
            ),
          ],
        ),
        drawer: const MCGDrawer(),
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
                "0",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
              foregroundColor: Colors.white,
              label: "Erdgeschoss",
              labelStyle: const TextStyle(fontSize: 18.0),
              onTap: () {
                setState(() {
                  _setSelectedPlan(_loadPlan(0), 0);
                });
              },
            ),
            SpeedDialChild(
              child: const Text(
                "1",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
              foregroundColor: Colors.white,
              label: "Obergeschoss",
              labelStyle: const TextStyle(fontSize: 18.0),
              onTap: () {
                setState(() {
                  _setSelectedPlan(_loadPlan(1), 1);
                });
              },
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            screenWidth = constraints.maxWidth;
            screenHeight = constraints.maxHeight;

            if (screenWidth * 125 / 300 < screenHeight) {
              // fix plan size to 90% of width
              planHeight = 125 / 300 * screenWidth * 0.9;
              planWidth = screenWidth * 0.9;
            } else {
              // fix plan size to 90% of height
              planHeight = screenHeight * 0.9;
              planWidth = 300 / 125 * screenHeight * 0.9;
            }

            offsetX = (screenWidth - planWidth) / 2;
            offsetY = (screenHeight - planHeight) / 2;

            Offset childWasTappedAt = Offset.zero;
            var transformationController = TransformationController();

            return GestureDetector(
              onTapUp: (TapUpDetails details) {
                childWasTappedAt = transformationController.toScene(
                  details.localPosition,
                );
                List<Room> rooms = [];
                if (_currentFloor == 0) {
                  rooms = _rooms[0];
                } else if (_currentFloor == 1) {
                  rooms = _rooms[1];
                }
                for (Room room in rooms) {
                  if (childWasTappedAt.dx > room.startX / 300 * planWidth + offsetX &&
                      childWasTappedAt.dx < room.endX / 300 * planWidth + offsetX &&
                      childWasTappedAt.dy > room.startY / 300 * planWidth + offsetY &&
                      childWasTappedAt.dy < room.endY / 300 * planWidth + offsetY) {
                    _showBottomSheet(context, room);
                  }
                }
              },
              child: InteractiveViewer(
                transformationController: transformationController,
                maxScale: 5,
                scaleFactor: 2,
                child: Container(
                  constraints: const BoxConstraints.expand(),
                  child: Container(
                    child: _selectedPlan,
                  ),
                ),
              ),
            );
          },
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
