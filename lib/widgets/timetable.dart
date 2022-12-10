import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mcgapp/main.dart';
import 'package:mcgapp/widgets/bottom_sheet.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../classes/course.dart';
import '../classes/room.dart';
import '../screens/timetable_screen.dart';

double height = 80;
double headerHeight = 42;
double headerWidth = 42;
double padding = 2;

Course? getCourse(String time) {
  for (Course course in userCourses) {
    for (List<String> t in course.times) {
      if (t[0] == time) return course;
    }
  }
  return null;
}

class Timetable extends StatelessWidget {
  const Timetable({Key? key, required this.week}) : super(key: key);

  final String week;

  Widget _dayHeader(String day) {
    return Expanded(
      child: SizedBox(
        height: headerHeight,
        child: Center(
          child: week == weekType() && day == DateFormat('E', 'de').format(DateTime.now())
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
    return SizedBox(
      height: height + padding * 2,
      width: headerWidth,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(getTimesFromLesson(lesson).split(' - ')[0], style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text('$lesson', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(getTimesFromLesson(lesson).split(' - ')[1], style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
              TimetableEntry(course: getCourse('${week}Mo$index'), week: week, weekday: 'Montag', lesson: index),
              TimetableEntry(course: getCourse('${week}Di$index'), week: week, weekday: 'Dienstag', lesson: index),
              TimetableEntry(course: getCourse('${week}Mi$index'), week: week, weekday: 'Mittwoch', lesson: index),
              TimetableEntry(course: getCourse('${week}Do$index'), week: week, weekday: 'Donnerstag', lesson: index),
              TimetableEntry(course: getCourse('${week}Fr$index'), week: week, weekday: 'Freitag', lesson: index),
            ],
          );
        });
  }
}

String getTimesFromLesson(int lesson) {
  switch (lesson) {
    case 1:
      return '8:00 - 9:30';
    case 2:
      return '9:50 - 11:20';
    case 3:
      if (group!.level >= 10) return '11:30 - 13:00';
      return '12:00 - 13:30';
    case 4:
      return '13:40 - 15:10';
    case 5:
      return '15:15 - 16:45';
    default:
      return '0:00 - 0:00';
  }
}

class TimetableEntry extends StatelessWidget {
  const TimetableEntry({
    Key? key,
    required this.course,
    required this.week,
    required this.weekday,
    required this.lesson,
  }) : super(key: key);

  final Course? course;
  final String week;
  final String weekday;
  final int lesson;

  Room? get _room {
    String time = '$week${weekday.substring(0, 2)}$lesson';

    for (List<String> t in course!.times) {
      if (t[0] == time) return Room.fromNumber(t[1]);
    }
    return null;
  }

  List<Widget> get _details {
    return [
      ListTile(
        title: Text('${course!.subject.name} (${course!.title})'),
        leading: Icon(Icons.school, color: course!.subject.backgroundColor),
      ),
      ListTile(
        title: Text(getTimesFromLesson(lesson)),
        leading: const Icon(Icons.access_time_outlined),
      ),
      ListTile(
        title: Text('${course!.teacher.title} ${course!.teacher.lastname}'),
        leading: const Icon(Icons.person),
      ),
      ListTile(
        title: Text(_room?.number ?? ''),
        leading: const Icon(Icons.place),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: course == null
          ? SizedBox(height: height)
          : Padding(
              padding: EdgeInsets.all(padding),
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: course!.subject.backgroundColor,
                ),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  onTap: () {
                    showMCGBottomSheet(
                      context,
                      '$weekday, $lesson. Block ($week)',
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
                            course!.teacher.short,
                            style: TextStyle(fontSize: 10, color: course!.subject.foregroundColor),
                          ),
                          Text(
                            course!.subject.short,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: course!.subject.foregroundColor,
                            ),
                          ),
                          Text(
                            _room?.number ?? '',
                            style: TextStyle(fontSize: 10, color: course!.subject.foregroundColor),
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
