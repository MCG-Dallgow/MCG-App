import 'package:mcgapp/classes/teacher.dart';

enum Group {

  //class7a('7a', 7, 'MarcH'),
  //class7b('7b', 7, 'GrubM'),
  //class7c('7c', 7, 'GärtS'),
  //class7d('7d', 7, 'UrSoF'),
  //class7e('7e', 7, 'RaabI'),
  //class7f('7f', 7, 'RoggA'),
  //class8a('8a', 8, 'BohsC'),
  //class8b('8b', 8, 'FoerA'),
  //class8c('8c', 8, 'RublT'),
  //class8d('8d', 8, 'TillA'),
  //class8e('8e', 8, 'SteiC'),
  //class9a('9a', 9, 'TigöH'),
  //class9b('9b', 9, 'SchaR'),
  class9c('9c', 9, 'GöttO'),
  //class9d('9d', 9, 'SpanF'),
  //class9e('9e', 9, 'WillA'),
  //class10a('10a', 10, 'PlauS'),
  class10b('10b', 10, 'SchbN'),
  //class10c('10c', 10, 'KrügJ'),
  //class10d('10d', 10, 'KössA'),
  //class10e('10e', 10, 'PelcE'),
  class11_1('11_1', 11, 'HossA'),
  class11_2('11_2', 11, 'HabeJ'),
  class11_3('11_3', 11, 'KirsN'),
  class11_4('11_4', 11, 'WoizP'),
  class11_5('11_5', 11, 'SchulC');
  //class12_1('12_1', 12, 'GutsA'),
  //class12_2('12_2', 12, 'KiepF'),
  //class12_3('12_3', 12, 'WoizM'),
  //class12_4('12_4', 12, 'DornC'),
  //class12_5('12_5', 12, 'SydoA');

  const Group(this.name, this.level, this._teacher);
  final String name;
  final int level;
  final String _teacher;

  Teacher get teacher => Teacher.fromShort(_teacher);

  static Group fromName(String name) {
    return Group.values.firstWhere((e) => e.name == name);
  }
}
