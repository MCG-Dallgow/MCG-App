import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mcgapp/classes/timetable_entry.dart';
import 'package:mcgapp/main.dart';
import 'package:mcgapp/widgets/bottom_sheet.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../classes/course.dart';
import '../screens/timetable_screen.dart';

double height = 80;
double headerHeight = 42;
double headerWidth = 42;
double padding = 2;

_getWeekdayName(int weekday) {
  switch (weekday) {
    case 0: return 'Montag';
    case 1: return 'Dienstag';
    case 2: return 'Mittwoch';
    case 3: return 'Donnerstag';
    case 4: return 'Freitag';
  }
}

class Timetable extends StatelessWidget {
  const Timetable({Key? key, required this.timetable}) : super(key: key);

  final Map<String, List<RegularTimetableEntry>> timetable;

  Widget _dayHeader(String day) {
    return Expanded(
      child: SizedBox(
        height: headerHeight,
        child: Center(
          child: timetable['0']![0].week == weekType() && day == DateFormat('E', 'de').format(DateTime.now())
              ? CircleAvatar(
                  radius: 16,
                  backgroundColor: themeManager.colorSecondary,
                  foregroundColor: themeManager.colorStroke,
                  child: Text(day, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                )
              : Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _lessonHeader(int lesson) {
    List<String> times = [];
    switch (lesson) {
      case 1:
        times = ['8:00', '9:30'];
        break;
      case 2:
        times = ['9:50', '11:20'];
        break;
      case 3:
        if (group!.level >= 10) times = ['11:30', '13:00'];
        times = ['12:00', '13:30'];
        break;
      case 4:
        times = ['13:40', '15:10'];
        break;
      case 5:
        times = ['15:15', '16:45'];
        break;
      default:
        times = ['0:00', '0:00'];
    }


    return SizedBox(
      height: height + padding * 2,
      width: headerWidth,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(times[0], style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text('$lesson', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(times[1], style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('de_DE');
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Row(
            children: [
              SizedBox(height: headerHeight, width: headerWidth),
              _dayHeader('Mo'),
              _dayHeader('Di'),
              _dayHeader('Mi'),
              _dayHeader('Do'),
              _dayHeader('Fr'),
            ],
          );
        }
        return Row(
          children: [
            _lessonHeader(index),
            TimetableEntry(entry: timetable['0']!.firstWhereOrNull((e) => e.lesson == index)),
            TimetableEntry(entry: timetable['1']!.firstWhereOrNull((e) => e.lesson == index)),
            TimetableEntry(entry: timetable['2']!.firstWhereOrNull((e) => e.lesson == index)),
            TimetableEntry(entry: timetable['3']!.firstWhereOrNull((e) => e.lesson == index)),
            TimetableEntry(entry: timetable['4']!.firstWhereOrNull((e) => e.lesson == index)),
          ],
        );
      },
    );
  }
}

class TimetableEntry extends StatelessWidget {
  const TimetableEntry({
    Key? key,
    required this.entry,
  }) : super(key: key);

  final RegularTimetableEntry? entry;

  List<Widget> get _details {
    return [
      ListTile(
        title: Text('${entry!.course.subject.name} (${entry!.course.title})'),
        leading: Icon(Icons.school, color: entry!.course.subject.backgroundColor),
      ),
      ListTile(
        title: Text('${entry!.start} - ${entry!.end}'),
        leading: const Icon(Icons.access_time_outlined),
      ),
      ListTile(
        title: Text('${entry!.teacher.title} ${entry!.teacher.lastname}'),
        leading: const Icon(Icons.person),
      ),
      ListTile(
        title: Text(entry!.room.number),
        leading: const Icon(Icons.place),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: entry == null
          ? SizedBox(height: height)
          : Padding(
              padding: EdgeInsets.all(padding),
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: entry!.course.subject.backgroundColor,
                ),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  onTap: () {
                    showMCGBottomSheet(
                      context,
                      '${_getWeekdayName(entry!.weekday)}, ${entry!.lesson}. Block (${entry!.week})',
                      _details,
                      [],
                    );
                  },
                  child: SizedBox(
                    height: height,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry!.teacher.short,
                            style: TextStyle(fontSize: 10, color: entry!.course.subject.foregroundColor),
                          ),
                          Text(
                            entry!.course.subject.short,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: entry!.course.subject.foregroundColor,
                            ),
                          ),
                          Text(
                            entry!.room.number,
                            style: TextStyle(fontSize: 10, color: entry!.course.subject.foregroundColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
