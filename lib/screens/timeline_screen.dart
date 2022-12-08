import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mcgapp/classes/room.dart';
import 'package:mcgapp/screens/timetable_screen.dart';
import 'package:mcgapp/widgets/app_bar.dart';
import 'package:mcgapp/widgets/drawer.dart';
import 'package:mcgapp/widgets/timetable.dart';

import '../classes/course.dart';
import '../main.dart';
import '../widgets/bottom_sheet.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({Key? key}) : super(key: key);

  static const String routeName = '/timeline';

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MCGAppBar(title: const Text('Timeline')),
      drawer: const MCGDrawer(routeName: TimelineScreen.routeName),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return TimelineEntry(date: DateTime.now().add(Duration(days: index)));
        },
      ),
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
    String day = DateFormat('EEEE', 'de').format(date);

    return Card(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      color: themeManager.themeMode == ThemeMode.dark ? const Color(0xFF424242) : Colors.grey[300],
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
                TimelineSubject(week: week, day: day, lesson: 1),
                TimelineSubject(week: week, day: day, lesson: 2),
                TimelineSubject(week: week, day: day, lesson: 3),
                TimelineSubject(week: week, day: day, lesson: 4),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TimelineSubject extends StatelessWidget {
  const TimelineSubject({
    Key? key,
    required this.week,
    required this.day,
    required this.lesson,
  }) : super(key: key);

  final String week;
  final String day;
  final int lesson;

  @override
  Widget build(BuildContext context) {
    Course? course = getCourse('$week${day.substring(0, 2)}$lesson');
    if (course == null) return Container();

    return Padding(
      padding: const EdgeInsets.all(4),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(32)),
        onTap: () {
          showMCGBottomSheet(
            context,
            '$day, $lesson. Block ($week)',
            [
              ListTile(
                title: Text('${course.subject.name} (${course.title})'),
                leading: Icon(Icons.school, color: course.subject.backgroundColor),
              ),
              ListTile(
                title: Text(getTimesFromLesson(lesson)),
                leading: const Icon(Icons.access_time_outlined),
              ),
              ListTile(
                title: Text('${course.teacher.title} ${course.teacher.lastname}'),
                leading: const Icon(Icons.person),
              ),
              ListTile(
                title: Text(Room.fromTime('$week${day.substring(0, 2)}$lesson')!.number),
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
            border: Border.all(color: course.subject.backgroundColor, width: 2),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text('$lesson', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              course.circleAvatar,
            ],
          ),
        ),
      ),
    );
  }
}
