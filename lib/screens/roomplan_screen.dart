import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mcgapp/classes/room.dart';
import 'package:mcgapp/main.dart';
import 'package:mcgapp/theme/theme_constants.dart';

import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';

class RoomplanScreen extends StatefulWidget {
  const RoomplanScreen({Key? key}) : super(key: key);

  @override
  State<RoomplanScreen> createState() => _RoomplanScreenState();
}

class _RoomplanScreenState extends State<RoomplanScreen> {
  final List<Room> _rooms0 = [];
  final List<Room> _rooms1 = [];
  Widget _selectedPlan = const Center(child: Text("not loaded"));
  String _currentFloor = '';
  String appBarTitle = "Raumplan";

  Future<void> loadJsonData() async {
    var jsonText = await rootBundle.loadString("assets/data/rooms.json");

    setState(() {
      List data = json.decode(jsonText)['rooms'];
      for (int i = 0; i < data.length; i++) {
        Room room = Room.fromJson(data, i);

        if (room.number.startsWith('0')) {
          //print("Room 0.");
          _rooms0.add(room);
          //print("_rooms0:");
          //_rooms0.forEach((element) { print(element.number); });
        } else if (room.number.startsWith('1')) {
          _rooms1.add(room);
        }
      }
    });

    _setSelectedPlan(_plan0(), '0');
  }

  @override
  void initState() {
    super.initState();
    loadJsonData();
    _setSelectedPlan(_plan0(), '0');
  }

  List<Widget> _loadRooms(List<Room> rooms, String floor) {
    List<Widget> roomWidgets = [];

    for (Room room in rooms) {
      roomWidgets.add(
        Positioned(
          left: room.startX,
          top: room.startY,
          height: room.endY - room.startY,
          width: room.endX - room.startX,
          child: Container(
            color: Colors.green.shade200,
            child: Center(
              child: Text(
                room.number,
                style: const TextStyle(fontSize: 5),
              ),
            ),
          ),
        ),
      );
    }

    roomWidgets.add(
      Positioned(
        //height: 300,
        //width: 500,
        //left: 0,
        //right: 0,
        //bottom: 83,
        child: SvgPicture.asset(
          fit: BoxFit.fill,
          'assets/images/roomplan_$floor.svg',
          width: 300,
          height: 125,
          color: themeManager.colorStroke,
        ),
      ),
    );

    return roomWidgets;
  }

  Widget _plan0() {
    return Stack(
        alignment: Alignment.topLeft, children: _loadRooms(_rooms0, '0'));
  }

  Widget _plan1() {
    return Stack(
      alignment: Alignment.topLeft,
      children: _loadRooms(_rooms1, '1'),
    );
  }

  void _setSelectedPlan(Widget plan, String floor) {
    setState(() {
      _selectedPlan = plan;
      _currentFloor = floor;

      if (floor == '0') {
        appBarTitle = "Raumplan - Erdgeschoss";
      } else if (floor == '1') {
        appBarTitle = "Raumplan - 1. Obergeschoss";
      }
    });
  }

  void _showBottomSheet(context, Room room) {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: [
            /*Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0))),
              child: ListView(
                children: [*/
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
                child: Text(room.name,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            /*SizedBox(
                    height: 200,
                    child: Image(image: AssetImage(room.image)),
                  ),*/
            ListTile(
              leading: const Icon(Icons.account_tree),
              title: Text("Art: ${room.type}"),
            ),
            ListTile(
              leading: const Icon(Icons.numbers),
              title: Text("Raumnummer: ${room.number}"),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text("Raumverantwortlicher: ${room.teacher}"),
            )
          ],
        );
        /*),
            ),
          ],
        );
      },*/
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Offset childWasTappedAt = Offset.zero;
    var transformationController = TransformationController();
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
                rooms.addAll(_rooms0.map((e) => e.number));
                rooms.addAll(_rooms1.map((e) => e.number));
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
              backgroundColor: colorAccent,
              foregroundColor: Colors.white,
              label: "Erdgeschoss",
              labelStyle: const TextStyle(fontSize: 18.0),
              onTap: () {
                setState(() {
                  _setSelectedPlan(_plan0(), '0');
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
              backgroundColor: colorAccent,
              foregroundColor: Colors.white,
              label: "1. Obergeschoss",
              labelStyle: const TextStyle(fontSize: 18.0),
              onTap: () {
                setState(() {
                  _setSelectedPlan(_plan1(), '1');
                });
              },
            ),
          ],
        ),
        body: GestureDetector(
          onTapUp: (TapUpDetails details) {
            childWasTappedAt = transformationController.toScene(
              details.localPosition,
            );
            List<Room> rooms = [];
            if (_currentFloor == '0') {
              rooms = _rooms0;
            } else if (_currentFloor == '1') {
              rooms = _rooms1;
            }
            for (Room room in rooms) {
              if (childWasTappedAt.dx > room.startX &&
                  childWasTappedAt.dx < room.endX &&
                  childWasTappedAt.dy > room.startY &&
                  childWasTappedAt.dy < room.endY) {
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
