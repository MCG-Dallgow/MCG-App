import 'package:flutter/material.dart';

import 'package:mcgapp/widgets/app_bar.dart';
import 'package:mcgapp/widgets/drawer.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({Key? key}) : super(key: key);

  static const String routeName = '/timetable';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
            appBar: MCGAppBar(
              title: 'Stundenplan',
              bottom: const TabBar(
                tabs: <Widget>[
                  Tab(text: 'A-Woche'),
                  Tab(text: 'B-Woche'),
                ],
              ),
            ),
            drawer: const MCGDrawer(routeName: TimetableScreen.routeName),
            body: const TabBarView(
              children: <Widget>[
                Center(
                  child: Text("Stundenplan A-Woche")
                ),
                Center(
                  child: Text("Stundenplan B-Woche")
                ),
              ],
            )
        )
    );
  }
}
