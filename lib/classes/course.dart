import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mcgapp/classes/grade.dart';

class Course {
  String title;
  String displayName;
  String short;
  Color backgroundColor;

  Course({
    required this.title,
    required this.displayName,
    required this.short,
    required this.backgroundColor,
  });

  Color get foregroundColor => backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

  List<Grade> get courseGrades {
    List<Grade> courseGrades = [];

    for (Grade grade in grades) {
      if (grade.course == this) courseGrades.add(grade);
    }
    courseGrades.sort((a, b) => int.parse(DateFormat('yyyyMMdd').format(b.date))
        .compareTo(int.parse(DateFormat('yyyyMMdd').format(a.date))));
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
      backgroundColor: backgroundColor,
      child: Text(
        short,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: foregroundColor,
        ),
      ),
    );
  }

  static Course? fromTitle(String title) {
    for (Course course in courses) {
      if (course.title == title) return course;
    }
    return null;
  }
}

List<Course> courses = [
  Course(
    title: 'Biologie',
    displayName: 'Biologie',
    short: 'Bio',
    backgroundColor: Colors.green.shade800,
  ),
  Course(
    title: 'Chemie',
    displayName: 'Chemie',
    short: 'Che',
    backgroundColor: Colors.green,
  ),
  Course(
    title: 'Deutsch',
    displayName: 'Deutsch',
    short: 'Deu',
    backgroundColor: Colors.red,
  ),
  Course(
    title: 'Englisch',
    displayName: 'Englisch',
    short: 'Eng',
    backgroundColor: Colors.yellow,
  ),
  Course(
    title: 'evangelische Religion',
    displayName: 'evangelische Religion',
    short: 'eRe',
    backgroundColor: Colors.purple.shade300,
  ),
  Course(
    title: 'Geschichte',
    displayName: 'Geschichte',
    short: 'Ges',
    backgroundColor: Colors.brown.shade400,
  ),
  Course(
    title: 'Geographie',
    displayName: 'Geographie',
    short: 'Geo',
    backgroundColor: Colors.deepPurple,
  ),
  Course(
    title: 'Informatik',
    displayName: 'Informatik',
    short: 'Inf',
    backgroundColor: Colors.teal,
  ),
  Course(
    title: 'katholische Religion',
    displayName: 'katholische Religion',
    short: 'kRe',
    backgroundColor: Colors.purple.shade700,
  ),
  Course(
    title: 'Kunst',
    displayName: 'Kunst',
    short: 'Kun',
    backgroundColor: Colors.pinkAccent,
  ),
  Course(
    title: 'LER',
    displayName: 'LER',
    short: 'LER',
    backgroundColor: Colors.purple,
  ),
  Course(
    title: 'Mathematik',
    displayName: 'Mathematik',
    short: 'Mat',
    backgroundColor: Colors.blue.shade900,
  ),
  Course(
    title: 'Musik',
    displayName: 'Musik',
    short: 'Mus',
    backgroundColor: Colors.brown.shade700,
  ),
  Course(
    title: 'Physik',
    displayName: 'Physik',
    short: 'Phy',
    backgroundColor: Colors.blue,
  ),
  Course(
    title: 'Politische Bildung',
    displayName: 'Politische Bildung',
    short: 'PB',
    backgroundColor: Colors.grey,
  ),
  Course(
    title: 'Seminarkurs',
    displayName: 'Seminarkurs',
    short: 'SK',
    backgroundColor: Colors.blueGrey,
  ),
  Course(
    title: 'Spanisch',
    displayName: 'Spanisch',
    short: 'Spa',
    backgroundColor: Colors.orangeAccent.shade700,
  ),
  Course(
    title: 'Sport',
    displayName: 'Sport',
    short: 'Spo',
    backgroundColor: Colors.brown,
  ),
  Course(
    title: 'Wirtschaft-Arbeit-Technik',
    displayName: 'Wirtschaft-Arbeit-Technik',
    short: 'WAT',
    backgroundColor: Colors.grey.shade300,
  ),
];

void sortCourses() {
  courses.sort((a, b) => a.displayName.compareTo(b.displayName));
}