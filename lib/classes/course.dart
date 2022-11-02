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
    color: Colors.green.shade800,
  ),
  Course(
    title: 'Chemie',
    displayName: 'Chemie',
    short: 'Che',
    color: Colors.green,
  ),
  Course(
    title: 'Deutsch',
    displayName: 'Deutsch',
    short: 'Deu',
    color: Colors.red,
  ),
  Course(
    title: 'Englisch',
    displayName: 'Englisch',
    short: 'Eng',
    color: Colors.yellow,
  ),
  Course(
    title: 'evangelische Religion',
    displayName: 'evangelische Religion',
    short: 'eRe',
    color: Colors.purple.shade300,
  ),
  Course(
    title: 'Geschichte',
    displayName: 'Geschichte',
    short: 'Ges',
    color: Colors.brown.shade400,
  ),
  Course(
    title: 'Geographie',
    displayName: 'Geographie',
    short: 'Geo',
    color: Colors.deepPurple,
  ),
  Course(
    title: 'Informatik',
    displayName: 'Informatik',
    short: 'Inf',
    color: Colors.teal,
  ),
  Course(
    title: 'katholische Religion',
    displayName: 'katholische Religion',
    short: 'kRe',
    color: Colors.purple.shade700,
  ),
  Course(
    title: 'Kunst',
    displayName: 'Kunst',
    short: 'Kun',
    color: Colors.pinkAccent,
  ),
  Course(
    title: 'LER',
    displayName: 'LER',
    short: 'LER',
    color: Colors.purple,
  ),
  Course(
    title: 'Mathematik',
    displayName: 'Mathematik',
    short: 'Mat',
    color: Colors.blue.shade900,
  ),
  Course(
    title: 'Musik',
    displayName: 'Musik',
    short: 'Mus',
    color: Colors.brown.shade700,
  ),
  Course(
    title: 'Physik',
    displayName: 'Physik',
    short: 'Phy',
    color: Colors.blue,
  ),
  Course(
    title: 'Politische Bildung',
    displayName: 'Politische Bildung',
    short: 'PB',
    color: Colors.grey,
  ),
  Course(
    title: 'Seminarkurs',
    displayName: 'Seminarkurs',
    short: 'SK',
    color: Colors.blueGrey,
  ),
  Course(
    title: 'Spanisch',
    displayName: 'Spanisch',
    short: 'Spa',
    color: Colors.orangeAccent.shade700,
  ),
  Course(
    title: 'Sport',
    displayName: 'Sport',
    short: 'Spo',
    color: Colors.brown,
  ),
  Course(
    title: 'Wirtschaft-Arbeit-Technik',
    displayName: 'Wirtschaft-Arbeit-Technik',
    short: 'WAT',
    color: Colors.grey.shade300,
  ),
];

void sortCourses() {
  courses.sort((a, b) => a.displayName.compareTo(b.displayName));
}