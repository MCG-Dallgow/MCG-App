import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mcgapp/classes/grade.dart';
import 'package:mcgapp/classes/room.dart';
import 'package:mcgapp/classes/teacher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'group.dart';

enum Subject {
  error('Fehler', '---', Colors.black),
  bio('Biologie', 'Bio', Color(0xFF2E7D32)),
  che('Chemie', 'Che', Colors.green),
  deu('Deutsch', 'Deu', Colors.red),
  eng('Englisch', 'Eng', Colors.yellow),
  ere('evangelische Religion', 'eRe', Color(0xFFBA68C8)),
  fra('Französisch', 'Fra', Colors.lightBlueAccent),
  ges('Geschichte', 'Ges', Color(0xFF8D6E63)),
  geo('Geographie', 'Geo', Colors.deepPurple),
  inf('Informatik', 'Inf', Colors.teal),
  kRe('katholische Religion', 'kRe', Color(0xFF7B1FA2)),
  kun('Kunst', 'Kun', Colors.pinkAccent),
  lat('Latein', 'Lat', Colors.limeAccent),
  ler('LER', 'LER', Colors.purple),
  mat('Mathematik', 'Mat', Color(0xFF0D47A1)),
  mus('Musik', 'Mus', Color(0xFF5D4037)),
  phy('Physik', 'Phy', Colors.blue),
  pb('Politische Bildung', 'PB', Colors.grey),
  sk('Seminarkurs', 'SK', Colors.blueGrey),
  spa('Spanisch', 'Spa', Color(0xFFFF6D00)),
  spo('Sport', 'Spo', Colors.brown),
  tec('Technik', 'Tec', Color(0xFF80DEEA)),
  wat('Wirtschaft-Arbeit-Technik', 'WAT', Color(0xFFE0E0E0));

  const Subject(this.name, this.short, this.backgroundColor);
  final String name;
  final String short;
  final Color backgroundColor;

  Color get foregroundColor => backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

  static Subject fromShort(String short) {
    return Subject.values.firstWhere((e) => e.short == short, orElse: () => Subject.error);
  }
}

Map<String, Course> courses = {};
List<Course> userCourses = [];
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Group? group;

setUserCourses(List<Course> courses) async {
  userCourses = courses;

  SharedPreferences prefs = await _prefs;
  prefs.setStringList('courses-${group!.level}', userCourses.map((course) => course.title).toList());
}

class Course {
  late String title;
  late Subject subject;
  late Teacher teacher;
  late List<List<String>> times;

  Course({
    required this.title,
    required this.subject,
    required this.teacher,
    required this.times,
  });

  List<Room> get rooms {
    List<Room> rooms = [];
    for (List<String> time in times) {
      Room room = Room.fromNumber(time[1]);
      if (!rooms.contains(room)) {
        rooms.add(room);
      }
    }
    return rooms;
  }

  List<Grade> get courseGrades {
    List<Grade> courseGrades = [];

    for (Grade grade in Grade.grades) {
      if (grade.course.title == title) courseGrades.add(grade);
    }
    courseGrades.sort((a, b) =>
        int.parse(DateFormat('yyyyMMdd').format(b.date)).compareTo(int.parse(DateFormat('yyyyMMdd').format(a.date))));
    return courseGrades;
  }

  double get gradeAverage {
    if (courseGrades.isEmpty) return -1;
    List<int> gradeList = courseGrades.map((e) => e.grade).toList();

    int sum = 0;
    for (var element in gradeList) {
      sum += element;
    }

    return sum / gradeList.length;
  }

  Widget get circleAvatar {
    return CircleAvatar(
      backgroundColor: subject.backgroundColor,
      child: Text(
        subject.short,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: subject.foregroundColor,
        ),
      ),
    );
  }

  @override
  bool operator ==(covariant Course other) => other.title == title;

  @override
  int get hashCode => title.hashCode;

  static Future<Map<String, Course>> getCourses(int level) async {
    var jsonText = await rootBundle.loadString('assets/data/courses/courses-$level.json');

    List data = json.decode(jsonText)['courses'];
    Map<String, Course> courses = {};
    for (int i = 0; i < data.length; i++) {
      Course course = Course.fromJson(data[i]);
      courses[course.title] = course;
    }

    return courses;
  }

  Course.fromTitle(String title) {
    Course? course;
    for (Course c in courses.values) {
      if (c.title == title) course = c;
    }
    this.title = course?.title ?? 'Unbekannter Kurs';
    subject = course?.subject ?? Subject.error;
    teacher = course?.teacher ?? Teacher.fromFirstAndLastName('', '');
    times = course?.times ?? [[], []];
  }

  Course.fromJson(var json) {
    title = json['title'];
    subject = Subject.fromShort(json['subject']);
    teacher = Teacher.fromFirstAndLastName(json['teacher'][0], json['teacher'][1]);
    List<List<String>> times = [];
    for (var time in json['times']) {
      times.add([time[0], time[1]]);
    }

    this.times = times;
  }
}
