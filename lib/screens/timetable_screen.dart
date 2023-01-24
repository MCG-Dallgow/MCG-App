import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:mcgapp/widgets/drawer.dart';

import '../classes/timetable_entry.dart';
import '../logic/api.dart';
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

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({Key? key}) : super(key: key);

  static const String routeName = '/timetable';

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  Widget _body = TabBarView(
    children: <Widget>[
      Container(),
      Container(),
    ],
  );

  Map<String, Map<String, List<RegularTimetableEntry>>> _timetable = {};

  DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateFormat format = DateFormat('yyyyMMdd');

  _loadTimetable() async {
    _timetable = await API.getRegularTimetable();
    setState(() {
      _body = TabBarView(
        children: <Widget>[
          Timetable(timetable: _timetable['A']!),
          Timetable(timetable: _timetable['B']!),
        ],
      );
    });
  }

  @override
  void initState() {
    _loadTimetable();
    super.initState();
  }
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
        body: _body,
      ),
    );
  }
}
