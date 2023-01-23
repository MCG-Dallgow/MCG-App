import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mcgapp/logic/api.dart';
import 'package:mcgapp/screens/timetable_screen.dart';
import 'package:mcgapp/widgets/app_bar.dart';
import 'package:mcgapp/widgets/drawer.dart';

import '../classes/timetable_entry.dart';
import '../main.dart';
import '../widgets/bottom_sheet.dart';

Map<DateTime, List<TimetableEntry>> _timetable = {};

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({Key? key}) : super(key: key);

  static const String routeName = '/timeline';

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final ScrollController _scrollController = ScrollController();

  DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateFormat format = DateFormat('yyyyMMdd');

  Widget _body = ListView.builder(
    itemBuilder: (BuildContext context, int index) {
      DateTime date = DateTime.now().add(Duration(days: index));
      return TimelineEntry(date: date);
    },
  );

  _loadTimetable() async {
    int start = int.parse(format.format(today));
    int end = int.parse(format.format(today.add(const Duration(days: 100))));

    _timetable.addAll(await API.getTimetable(start, end));

    setState(() {
      _body = ListView.builder(
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          DateTime date = today.add(Duration(days: index));
          return TimelineEntry(date: date);
        },
      );
    });
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      var triggerFetchMoreSize = 0.9 * _scrollController.position.maxScrollExtent;

      if (_scrollController.position.pixels > triggerFetchMoreSize) {
        // TODO: load more timetable data
      }
    });

    _loadTimetable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MCGAppBar(title: const Text('Timeline')),
      drawer: const MCGDrawer(routeName: TimelineScreen.routeName),
      body: _body,
    );
  }
}

class TimelineEntry extends StatelessWidget {
  const TimelineEntry({Key? key, required this.date}) : super(key: key);

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('de_DE');

    String week = weekType(week: weekNumber(date: date));

    return Card(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      color: themeManager.themeMode == ThemeMode.dark ? const Color(0xFF424242) : Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  radius: 20,
                  child: Text(
                    DateFormat('E', 'de').format(date),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('d. MMMM yyyy', 'de').format(date),
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text('$week-Woche'),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TimelineSubject(data: _timetable[date]?.firstWhereOrNull((e) => e.lesson == 1)),
                TimelineSubject(data: _timetable[date]?.firstWhereOrNull((e) => e.lesson == 2)),
                TimelineSubject(data: _timetable[date]?.firstWhereOrNull((e) => e.lesson == 3)),
                TimelineSubject(data: _timetable[date]?.firstWhereOrNull((e) => e.lesson == 4)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TimelineSubject extends StatelessWidget {
  const TimelineSubject({Key? key, required this.data}) : super(key: key);

  final TimetableEntry? data;

  @override
  Widget build(BuildContext context) {
    if (data == null) return Container();

    String week = weekType(week: weekNumber(date: data!.date));
    String day = DateFormat('EEEE', 'de').format(data!.date);

    return Padding(
      padding: const EdgeInsets.all(4),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(32)),
        onTap: () {
          showMCGBottomSheet(
            context,
            '$day, ${data!.lesson}. Block ($week)',
            [
              ListTile(
                title: Text('${data!.course.subject.name} (${data!.course.title})'),
                leading: Icon(Icons.school, color: data!.course.subject.backgroundColor),
              ),
              ListTile(
                title: Text('${data!.start} - ${data!.end}'),
                leading: const Icon(Icons.access_time_outlined),
              ),
              ListTile(
                title: Text('${data!.regTeacher.title} ${data!.regTeacher.lastname}'),
                leading: const Icon(Icons.person),
              ),
              ListTile(
                title: Text(data!.regRoom.number),
                leading: const Icon(Icons.place),
              ),
            ],
            [],
          );
        },
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(32)),
            border: Border.all(color: data!.course.subject.backgroundColor, width: 2),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('${data!.lesson}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              data!.course.circleAvatar,
            ],
          ),
        ),
      ),
    );
  }
}
