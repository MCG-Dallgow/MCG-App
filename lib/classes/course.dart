import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mcgapp/classes/grade.dart';
import 'package:mcgapp/classes/room.dart';
import 'package:mcgapp/classes/subject.dart';
import 'package:mcgapp/classes/teacher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'group.dart';

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
  late List only;
  late bool required;

  Course({
    required this.title,
    required this.subject,
    required this.teacher,
    required this.times,
    required this.only,
    required this.required,
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

  static Future<Map<String, Course>> getCourses(Group group) async {
    var jsonText = await rootBundle.loadString('assets/data/courses/courses-${group.level}.json');

    List data = json.decode(jsonText)['courses'];
    Map<String, Course> courses = {};
    for (int i = 0; i < data.length; i++) {
      Course course = Course.fromJson(data[i]);

      if (course.only.isEmpty || course.only.contains(group.name)) {
        courses[course.title] = course;
      }
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
    teacher = course?.teacher ?? Teacher.fromShort('');
    times = course?.times ?? [[], []];
  }

  Course.fromJson(var json) {
    title = json['title'];
    subject = Subject.fromShort(json['subject']);
    teacher = Teacher.fromShort(json['teacher']);

    List<List<String>> times = [];
    for (var time in json['times']) {
      times.add([time[0], time[1]]);
    }
    this.times = times;

    only = json['only'] ?? [];
    required = json['required'] ?? false;
  }
}
