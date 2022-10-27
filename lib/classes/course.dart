import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mcgapp/classes/grade.dart';

class Course {
  String title;
  String displayName;
  String short;
  Color color;

  Course({
    required this.title,
    required this.displayName,
    required this.short,
    required this.color,
  });

  List<Grade> get courseGrades {
    List<Grade> courseGrades = [];
    courseGrades.sort((a, b) => int.parse(DateFormat('yyyyMMdd').format(b.date))
          .compareTo(int.parse(DateFormat('yyyyMMdd').format(a.date))));

    for (Grade grade in grades) {
      if (grade.course == this) courseGrades.add(grade);
    }
    return courseGrades;
  }

  double get gradeAverage {
    if (courseGrades.isEmpty) return -1;
    List<int> gradeList = courseGrades.map((e) => e.grade).toList();

    int sum = 0;
    for (var element in gradeList) { sum += element; }

    return sum / gradeList.length;
  }

  Widget get circleAvatar {
    return CircleAvatar(
      backgroundColor: color,
      child: Text(
        short,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

List<Course> courses = [
  Course(
    title: 'ChG11_1',
    displayName: 'Chemie',
    short: 'Che',
    color: Colors.green,
  ),
  Course(
    title: 'EnG11_2',
    displayName: 'Englisch',
    short: 'Eng',
    color: Colors.deepOrange.shade800,
  ),
  Course(
    title: 'MaL11',
    displayName: 'Mathematik',
    short: 'Mat',
    color: Colors.blue.shade900,
  ),
];

void sortCourses() {
  courses.sort((a, b) => a.displayName.compareTo(b.displayName));
}