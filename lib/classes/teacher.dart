import 'dart:convert';

import 'package:flutter/services.dart';

Map<String, Teacher> teachers = {};

class Teacher {
  late String anrede;
  late String vorname;
  late String nachname;
  late String kuerzel;
  late String faecher;
  late String email;

  Teacher({
    required this.anrede,
    required this.vorname,
    required this.nachname,
    required this.kuerzel,
    required this.faecher,
    required this.email,
  });

  static Future<Map<String, Teacher>> getTeachers() async {
    var jsonText = await rootBundle.loadString('assets/data/teachers.json');

    List data = json.decode(jsonText)['teachers'];
    Map<String, Teacher> teachers = {};
    for (int i = 0; i < data.length; i++) {
      Teacher teacher = Teacher.fromJson(data, i);
      teachers['${teacher.vorname} ${teacher.nachname}'] = teacher;
    }

    return teachers;
  }

  Teacher.fromFirstAndLastName(String vorname, String nachname) {
    Teacher? teacher = teachers['$vorname $nachname'];

    anrede = teacher?.anrede ?? 'Herr';
    this.vorname = teacher?.vorname ?? 'Unbekannter';
    this.nachname = teacher?.nachname ?? 'Lehrer';
    kuerzel = teacher?.kuerzel ?? '-----';
    faecher = teacher?.faecher ?? '';
    email = teacher?.email ?? '';
  }

  Teacher.fromJson(var json, int index) {
    anrede = json[index]['anrede'];
    vorname = json[index]['vorname'];
    nachname = json[index]['nachname'];
    kuerzel = json[index]['kuerzel'];
    faecher = json[index]['faecher'];
    email = json[index]['email'];
  }
}