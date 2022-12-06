import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:mcgapp/widgets/drawer.dart';

import '../widgets/app_bar.dart';
import '../widgets/timetable.dart';

int weekNumber({DateTime? date}) {
  date ??= DateTime.now();
  int dayOfYear = int.parse(DateFormat('D').format(date));
  return ((dayOfYear - date.weekday + 10) / 7).floor();
}

String weekType({int? week}) {
  week ??= weekNumber();
  return week.isEven ? 'A' : 'B';
}

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({Key? key}) : super(key: key);

  static const String routeName = '/timetable';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: weekType() == 'A' ? 0 : 1,
      length: 2,
      child: Scaffold(
        appBar: MCGAppBar(
          title: const Text('Stundenplan'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                child: Text(
                  'A-Woche',
                  style: TextStyle(
                    fontSize: weekType() == 'A' ? 16 : 14,
                    fontWeight: weekType() == 'A' ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'B-Woche',
                  style: TextStyle(
                    fontSize: weekType() == 'B' ? 16 : 14,
                    fontWeight: weekType() == 'B' ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
        drawer: const MCGDrawer(routeName: TimetableScreen.routeName),
        body: const TabBarView(
          children: <Widget>[
            Timetable(week: 'A'),
            Timetable(week: 'B'),
          ],
        ),
      ),
    );
  }
}
