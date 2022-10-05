import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mcgapp/main.dart';
import 'package:mcgapp/theme/theme_constants.dart';

import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';
import '../widgets/search_bar.dart';

class RoomPlan extends StatefulWidget {
  const RoomPlan({Key? key}) : super(key: key);

  @override
  State<RoomPlan> createState() => _RoomPlanState();
}

class _RoomPlanState extends State<RoomPlan> {
  final List<String> _rooms = [];

  Future<void> loadJsonData() async {
    var jsonText = await rootBundle.loadString("assets/rooms.json");
    setState(() {
      var data = json.decode(jsonText);
      List test = [];
      test.addAll(data['raeume']);
      for (int i = 0; i < test.length; i++) {
        //print(test[i]);
        var test2 = data['raeume'][i]['Raeume'];
        for (int j = 0; j < test2.length; j++) {
          if (kDebugMode) {
            print(test2[j]['Raumnummer']);
          }
          _rooms.add(test2[j]['Raumnummer']);
        }
      }
      _rooms.sort((a, b) => a.compareTo(b));
    });
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
      constraints: const BoxConstraints.expand(),
      color: Colors.red,
      child: Container(
        color: Colors.grey,
        margin: const EdgeInsets.all(20.0),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Positioned(
              //height: 300,
              //width: 500,
              //left: 0,
              //right: 0,
              //bottom: 83,
              child: SvgPicture.asset(
                fit: BoxFit.fill,
                'assets/roomplan_0.svg',
                width: 200,
                height: 83,
                color: themeManager.colorStroke,
              ),
            ),
            /*Positioned(
              left: 50,
              right: 50,
              top: 0,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("hi"),
              ),
            )*/
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
          maxScale: 5,
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
            /*SpeedDialChild(
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
            ),*/
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

