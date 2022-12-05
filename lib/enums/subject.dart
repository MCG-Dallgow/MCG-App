import 'package:flutter/material.dart';

enum Subject {
  error('Fehler', '---', Colors.black),
  bio('Biologie', 'Bio', Color(0xFF2E7D32)),
  che('Chemie', 'Che', Colors.green),
  deu('Deutsch', 'Deu', Colors.red),
  eng('Englisch', 'Eng', Colors.yellow),
  ere('evangelische Religion', 'eRe', Color(0xFFBA68C8)),
  fra('Französisch', 'Fra', Colors.lightBlueAccent),
  ges('Geschichte', 'Ges', Color(0xFF8D6E63)),
  geo('Geographie', 'Geo', Colors.deepPurple),
  inf('Informatik', 'Inf', Colors.teal),
  kRe('katholische Religion', 'kRe', Color(0xFF7B1FA2)),
  kun('Kunst', 'Kun', Colors.pinkAccent),
  lat('Latein', 'Lat', Colors.limeAccent),
  ler('LER', 'LER', Colors.purple),
  mat('Mathematik', 'Mat', Color(0xFF0D47A1)),
  mus('Musik', 'Mus', Color(0xFF5D4037)),
  phy('Physik', 'Phy', Colors.blue),
  pb('Politische Bildung', 'PB', Colors.grey),
  sk('Seminarkurs', 'SK', Colors.blueGrey),
  spa('Spanisch', 'Spa', Color(0xFFFF6D00)),
  spo('Sport', 'Spo', Colors.brown),
  tec('Technik', 'Tec', Color(0xFF80DEEA)),
  wat('Wirtschaft-Arbeit-Technik', 'WAT', Color(0xFFE0E0E0));

  const Subject(this.name, this.short, this.backgroundColor);
  final String name;
  final String short;
  final Color backgroundColor;

  Color get foregroundColor => backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

  static Subject fromShort(String short) {
    return Subject.values.firstWhere((e) => e.short == short, orElse: () => Subject.error);
  }
}
