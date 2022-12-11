import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mcgapp/classes/room.dart';
import 'package:mcgapp/main.dart';
import 'package:mcgapp/widgets/bottom_sheet.dart';

import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';

class RoomplanScreen extends StatefulWidget {
  const RoomplanScreen({Key? key}) : super(key: key);

  static const String routeName = '/roomplan';

  @override
  State<RoomplanScreen> createState() => _RoomplanScreenState();
}

class _RoomplanScreenState extends State<RoomplanScreen> {
  final List<List<Room>> _rooms = [[], []];
  Widget _selectedPlan = const Center(child: Text('Wird geladen...'));
  int _currentFloor = 0;
  String _appBarTitle = 'Raumplan';

  late double _screenWidth;
  late double _screenHeight;
  late double _offsetX;
  late double _offsetY;
  late double _planWidth;
  late double _planHeight;

  Future<void> _loadRooms() async {
    Map<String, Room> rooms = await Room.getRooms();

    setState(() {
      for (Room room in rooms.values) {
        if (room.number.startsWith('0') || room.number == 'TH') {
          _rooms[0].add(room);
        } else if (room.number.startsWith('1')) {
          _rooms[1].add(room);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadRooms().then((_) => _setSelectedPlan(0));
  }

  Widget _loadPlan(int floor) => Stack(
        alignment: Alignment.topLeft,
        children: [
          Positioned(
            height: _planHeight,
            width: _planWidth,
            left: _offsetX,
            top: _offsetY,
            child: SvgPicture.asset(
              fit: BoxFit.fill,
              'assets/images/room_plan/room_plan_${floor}_${themeManager.themeMode == ThemeMode.dark ? 'dark' : 'light'}.svg',
              width: 300,
              height: 125,
            ),
          ),
        ],
      );

  void _setSelectedPlan(int floor) {
    setState(() {
      _selectedPlan = _loadPlan(floor);
      _currentFloor = floor;

      if (floor == 0) {
        _appBarTitle = 'Raumplan - Erdgeschoss';
      } else if (floor == 1) {
        _appBarTitle = 'Raumplan - Obergeschoss';
      }
    });
  }

  void _showBottomSheet(context, Room room) {
    showMCGBottomSheet(
      context,
      room.name,
      [
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
        ),
      ],
      [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MCGAppBar(
        title: Text(_appBarTitle),
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
      drawer: const MCGDrawer(routeName: RoomplanScreen.routeName),
      floatingActionButton: SpeedDial(
        icon: Icons.layers,
        activeIcon: Icons.close,
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
              '0',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
            foregroundColor: Theme.of(context).floatingActionButtonTheme.foregroundColor,
            label: 'Erdgeschoss',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                _setSelectedPlan(0);
              });
            },
          ),
          SpeedDialChild(
            child: const Text(
              '1',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
            foregroundColor: Theme.of(context).floatingActionButtonTheme.foregroundColor,
            label: 'Obergeschoss',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                _setSelectedPlan(1);
              });
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          _screenWidth = constraints.maxWidth;
          _screenHeight = constraints.maxHeight;

          if (_screenWidth * 125 / 300 < _screenHeight) {
            // fix plan size to 90% of width
            _planHeight = 125 / 300 * _screenWidth * 0.9;
            _planWidth = _screenWidth * 0.9;
          } else {
            // fix plan size to 90% of height
            _planHeight = _screenHeight * 0.9;
            _planWidth = 300 / 125 * _screenHeight * 0.9;
          }

          _offsetX = (_screenWidth - _planWidth) / 2;
          _offsetY = (_screenHeight - _planHeight) / 2;

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
                if (childWasTappedAt.dx > room.startX / 300 * _planWidth + _offsetX &&
                    childWasTappedAt.dx < room.endX / 300 * _planWidth + _offsetX &&
                    childWasTappedAt.dy > room.startY / 300 * _planWidth + _offsetY &&
                    childWasTappedAt.dy < room.endY / 300 * _planWidth + _offsetY) {
                  _showBottomSheet(context, room);
                }
              }
            },
            child: InteractiveViewer(
              transformationController: transformationController,
              maxScale: _screenHeight / _screenWidth * 3,
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
