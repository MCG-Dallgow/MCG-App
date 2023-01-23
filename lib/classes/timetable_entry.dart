import 'package:mcgapp/classes/course.dart';
import 'package:mcgapp/classes/room.dart';
import 'package:mcgapp/classes/teacher.dart';

class TimetableEntry {
  const TimetableEntry({
    required this.date,
    required this.start,
    required this.end,
    required this.lesson,
    required this.course,
    required this.regTeacher,
    required this.subTeacher,
    required this.regRoom,
    required this.subRoom,
  });

  final DateTime date;
  final String start;
  final String end;
  final int lesson;
  final Course course;
  final Teacher regTeacher;
  final Teacher subTeacher;
  final Room regRoom;
  final Room subRoom;
}

class RegularTimetableEntry{
  const RegularTimetableEntry({
    required this.week,
    required this.weekday,
    required this.start,
    required this.end,
    required this.lesson,
    required this.course,
    required this.teacher,
    required this.room,
  });

  final String week;
  final int weekday;
  final String start;
  final String end;
  final int lesson;
  final Course course;
  final Teacher teacher;
  final Room room;
}