import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mcgapp/classes/grade.dart';
import 'package:mcgapp/classes/room.dart';
import 'package:mcgapp/enums/subject.dart';
import 'package:mcgapp/classes/teacher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/group.dart';

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
  late List<Room> rooms;

  Course({
    required this.title,
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
  bool operator ==(covariant Course other) => other.title == title;

  @override
  int get hashCode => title.hashCode;

  Course.fromTitle(String title) {
    Course? course;
    for (Course c in courses.values) {
      if (c.title == title) course = c;
    }
    this.title = course?.title ?? 'Unbekannter Kurs';
    subject = course?.subject ?? Subject.error;
    teacher = course?.teacher ?? Teacher.fromShort('');
    rooms = course?.rooms ?? [];
  }
}
