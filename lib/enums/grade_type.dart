import 'package:flutter/material.dart';

enum GradeType {
  abipruefung('Abiturprüfung', Icon(Icons.book), 4),
  aufgabe('Aufgabe', Icon(Icons.task), 0),
  klassenarbeit('Klassenarbeit', Icon(Icons.book), 1),
  klausur('Klausur', Icon(Icons.book), 2),
  leistungskontrolle('Leistungskontrolle', Icon(Icons.directions_run), 0),
  mitarbeit('Mitarbeit', Icon(Icons.back_hand), 0),
  pruefung('Prüfung', Icon(Icons.book), 3),
  test('Test', Icon(Icons.book), 0),
  vortrag('Vortrag', Icon(Icons.co_present), 0);

  const GradeType(this.name, this.icon, this.id);
  final String name;
  final Icon icon;
  final int id;

  static GradeType fromName(String name) {
    return GradeType.values.byName(name.replaceAll('GradeType.', ''));
  }

  static List<GradeType> fromType(int type) {
    return GradeType.values.where((element) => element.id == type).toList();
  }

  static String getTypeName(int type) {
    switch (type) {
      case 0: return 'Reguläre Noten';
      case 1: return 'Klassenarbeiten';
      case 2: return 'Klausuren';
      case 3: return 'Prüfungen';
      case 4: return 'Abiturprüfungen';
    }
    return 'Ungültiger Typ';
  }
}
