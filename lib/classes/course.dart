import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mcgapp/classes/grade.dart';
import 'package:mcgapp/classes/room.dart';
import 'package:mcgapp/classes/teacher.dart';

enum Subject {
  biology('Biologie', 'Bio', Color(0xFF2E7D32)),
  chemistry('Chemie', 'Che', Colors.green),
  german('Deutsch', 'Deu', Colors.red),
  english('Englisch', 'Eng', Colors.yellow),
  religionE('evangelische Religion', 'eRe', Color(0xFFBA68C8)),
  french('Französisch', 'Fra', Colors.lightBlueAccent),
  history('Geschichte', 'Ges', Color(0xFF8D6E63)),
  geography('Geographie', 'Geo', Colors.deepPurple),
  informatics('Informatik', 'Inf', Colors.teal),
  religionK('katholische Religion', 'kRe', Color(0xFF7B1FA2)),
  art('Kunst', 'Kun', Colors.pinkAccent),
  latin('Latein', 'Lat', Colors.limeAccent),
  ler('LER', 'LER', Colors.purple),
  maths('Mathematik', 'Mat', Color(0xFF0D47A1)),
  music('Musik', 'Mus', Color(0xFF5D4037)),
  physics('Physik', 'Phy', Colors.blue),
  politics('Politische Bildung', 'PB', Colors.grey),
  sk('Seminarkurs', 'SK', Colors.blueGrey),
  spanish('Spanisch', 'Spa', Color(0xFFFF6D00)),
  pe('Sport', 'Spo', Colors.brown),
  technology('Technik', 'Tec', Color(0xFF80DEEA)),
  wat('Wirtschaft-Arbeit-Technik', 'WAT', Color(0xFFE0E0E0));

  const Subject(this.title, this.short, this.backgroundColor);
  final String title;
  final String short;
  final Color backgroundColor;

  Color get foregroundColor => backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
}

class Course {
  Subject subject;
  Teacher teacher;
  Room room;

  Course({
    required this.subject,
    required this.teacher,
    required this.room,
  });

  List<Grade> get courseGrades {
    List<Grade> courseGrades = [];

    for (Grade grade in Grade.grades) {
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

  static Course? fromTitle(String title) {
    for (Course course in courses) {
      if (course.subject.title == title) return course;
    }
    return null;
  }
}

List<Course> courses = Subject.values.map((e) => Course(
  subject: e,
  teacher: Teacher(
    anrede: 'Herr',
    vorname: 'Alexander',
    nachname: 'Tillner',
    kuerzel: 'TillA',
    faecher: 'Chemie, Geschichte',
    email: 'alexander.tillner@lk.brandenburg.de',
  ),
  room: Room(
    number: '1.69',
    name: '1.69',
    teacher: 'Herr Tillner',
    image: '',
    type: 'Gesellschaftswissenschaften',
    startX: 0,
    startY: 0,
    endX: 0,
    endY: 0,
  ),
)).toList();

void sortCourses() {
  courses.sort((a, b) => a.subject.title.compareTo(b.subject.title));
}
