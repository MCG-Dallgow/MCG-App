import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mcgapp/classes/subject.dart';

Map<String, Teacher> teachers = {};

class Teacher {
  late String title;
  late String firstname;
  late String lastname;
  late String short;
  late List<Subject> subjects;
  late String email;

  Teacher({
    required this.title,
    required this.firstname,
    required this.lastname,
    required this.short,
    required this.subjects,
    required this.email,
  });

  static Future<Map<String, Teacher>> getTeachers() async {
    var jsonText = await rootBundle.loadString('assets/data/teachers.json');

    List data = json.decode(jsonText)['teachers'];
    Map<String, Teacher> teachers = {};
    for (int i = 0; i < data.length; i++) {
      Teacher teacher = Teacher.fromJson(data, i);
      teachers['${teacher.firstname} ${teacher.lastname}'] = teacher;
    }

    return teachers;
  }

  Teacher.fromFirstAndLastName(String firstname, String lastname) {
    Teacher? teacher = teachers['$firstname $lastname'];

    title = teacher?.title ?? 'Herr';
    this.firstname = teacher?.firstname ?? 'Unbekannter';
    this.lastname = teacher?.lastname ?? 'Lehrer';
    short = teacher?.short ?? '-----';
    subjects = teacher?.subjects ?? [];
    email = teacher?.email ?? '';
  }

  Teacher.fromJson(var json, int index) {
    title = json[index]['title'];
    firstname = json[index]['firstname'];
    lastname = json[index]['lastname'];
    short = json[index]['short'];
    subjects = (json[index]['subjects'] as List).map((e) => Subject.fromShort(e)).toList();
    email = json[index]['email'];
  }
}