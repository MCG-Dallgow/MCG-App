import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mcgapp/classes/grade.dart';
import 'package:mcgapp/classes/room.dart';
import 'package:mcgapp/enums/subject.dart';
import 'package:mcgapp/classes/teacher.dart';
import 'package:mcgapp/logic/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/group.dart';

Map<String, Course> courses = {};
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Group? group;

saveCourses(Map<String, Course> courses) async {
  SharedPreferences prefs = await _prefs;
  
  List<String> encodedCourses = [];
  for (Course course in courses.values) {
    encodedCourses.add(jsonEncode({
      'name': course.name,
      'subject': course.subject.short,
      'teacher': course.teacher.short,
      'rooms': course.rooms.map((e) => e.number).toList(),
    }));
  }
  
  prefs.setString('courses', jsonEncode(encodedCourses));
}

loadCourses() async {
  SharedPreferences prefs = await _prefs;
  String? courseData = prefs.getString('courses');
  if (courseData == null) {
    courses = await API.getCourses();
    saveCourses(courses);
  } else {
    List<dynamic> encodedCourses = jsonDecode(courseData);
    for (String encodedCourse in encodedCourses) {
      Map<String, dynamic> course = jsonDecode(encodedCourse);
      List<Room> rooms = [];
      for (var room in course['rooms']) {
        rooms.add(Room.fromNumber(room as String));
      }
      
      courses[course['name']] = Course(
        name: course['name'],
        subject: Subject.fromShort(course['subject']),
        teacher: Teacher.fromShort(course['teacher']),
        rooms: rooms,
      );
    }
  }
}

class Course {
  late String name;
  late Subject subject;
  late Teacher teacher;
  late List<Room> rooms;

  Course({
    required this.name,
    required this.subject,
    required this.teacher,
    required this.rooms,
  });

  List<Grade> get courseGrades {
    List<Grade> courseGrades = [];

    for (Grade grade in Grade.grades) {
      if (grade.course == this) courseGrades.add(grade);
    }
    courseGrades.sort((a, b) =>
        int.parse(DateFormat('yyyyMMdd').format(b.date)).compareTo(int.parse(DateFormat('yyyyMMdd').format(a.date))));
    return courseGrades;
  }

  double get gradeAverage {
    if (courseGrades.isEmpty) return -1;
    Map<int, double> typeAverages = {};

    for (int typeId in gradeTypes.keys) {
      List<Grade> typeGrades = courseGrades.where((element) => element.type.id == typeId).toList();
      if (typeGrades.isNotEmpty) {
        int sum = 0;
        for (var element in typeGrades) {
          sum += element.grade;
        }
        double average = sum / typeGrades.length;
        typeAverages[typeId] = average;
      }
    }

    double average = 0;
    for (int typeId in typeAverages.keys) {
      average += typeAverages[typeId]! * (typeAverages.values.length > 1 ? gradeTypes[typeId]! : 1);
    }
    return average;
  }

  Map<int, double> get gradeTypes {
    Map<int, double> gradeTypes = {};

    if (group!.level > 10) {
      gradeTypes[0] = 0.67;
      gradeTypes[2] = 0.33;
    } else {
      switch (subject) {
        case Subject.deu:
        case Subject.mat:
        case Subject.eng:
        case Subject.spa:
        case Subject.fra:
        case Subject.lat:
          gradeTypes[0] = 0.5;
          gradeTypes[1] = 0.5;
          break;
        default:
          gradeTypes[0] = 1;
          break;
      }
    }

    return gradeTypes;
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
  bool operator ==(covariant Course other) => other.name == name;

  @override
  int get hashCode => name.hashCode;

  Course.fromName(String name) {
    Course? course;
    for (Course c in courses.values) {
      if (c.name == name) course = c;
    }
    this.name = course?.name ?? 'Unbekannter Kurs';
    subject = course?.subject ?? Subject.error;
    teacher = course?.teacher ?? Teacher.fromShort('');
    rooms = course?.rooms ?? [];
  }
}
