import 'package:flutter/material.dart';

enum Subject {
  error('Fehler', '---', 0xFF000000),
  bio('Biologie', 'Bio', 0xFF2E7D32),
  che('Chemie', 'Che', 0xFF4CAF50),
  deu('Deutsch', 'Deu', 0xFFF44336),
  eng('Englisch', 'Eng', 0xFFFFEB3B),
  ere('evangelische Religion', 'eRe', 0xFFBA68C8),
  fra('Französisch', 'Fra', 0xFF40C4FF),
  ges('Geschichte', 'Ges', 0xFF8D6E63),
  geo('Geographie', 'Geo', 0xFF673AB7),
  inf('Informatik', 'Inf', 0xFF009688),
  kRe('katholische Religion', 'kRe', 0xFF7B1FA2),
  kun('Kunst', 'Kun', 0xFFFF4081),
  lat('Latein', 'Lat', 0xFFEEFF41),
  ler('LER', 'LER', 0xFF9C27B0),
  mat('Mathematik', 'Mat', 0xFF0D47A1),
  mus('Musik', 'Mus', 0xFF5D4037),
  phy('Physik', 'Phy', 0xFF2196F3),
  pb('Politische Bildung', 'PB', 0xFF9E9E9E),
  sk('Seminarkurs', 'SK', 0xFF607D8B),
  spa('Spanisch', 'Spa', 0xFFFF6D00),
  spo('Sport', 'Spo', 0xFF795548),
  tec('Technik', 'Tec', 0xFF80DEEA),
  wat('WAT', 'WAT', 0xFFE0E0E0);

  const Subject(this.name, this.short, this._backgroundColor);
  final String name;
  final String short;
  final int _backgroundColor;

  Color get backgroundColor => Color(_backgroundColor);

  Color get foregroundColor => backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

  static Subject fromShort(String short) {
    return Subject.values.firstWhere((e) => e.short == short, orElse: () => Subject.error);
  }
}
