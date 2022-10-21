import 'package:flutter/material.dart';
import 'package:html/parser.dart';

class SubstitutionEntry extends StatelessWidget {
  const SubstitutionEntry({
    Key? key,
    required this.group,
    required this.lesson,
    required this.times,
    this.teacherOld,
    this.teacherNew,
    this.roomOld,
    this.roomNew,
    this.courseOld,
    this.courseNew,
    this.type,
    this.description,
  }) : super(key: key);

  final String group; // Klasse(nstufe), auf die die Änderung zutrifft
  final String lesson; // Schulstunde ("3-4" -> 2. Block)
  final String times; // Zeiten der Stunde (z.B. 11:30-13:00)
  final String? teacherOld; // regulärer Lehrer
  final String? teacherNew; // Vertretungslehrer
  final String? roomOld; // regulärer Raum
  final String? roomNew; // Raumänderung
  final String? courseOld; // reguläre(r/s) Fach/Kurs
  final String? courseNew; // Fach-/Kursänderung
  final String? type; // Art der Änderung (Entfall, Raumänderung usw.)
  final String? description; // Vertretungstext

  static String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = (parse(document.body?.text).documentElement?.text ?? htmlString)
        .replaceAll('&auml;', 'ä')
        .replaceAll('&ouml;', 'ö')
        .replaceAll('&uuml;', 'ü');
    return parsedString;
  }

  factory SubstitutionEntry.fromJson(var data) {
    RegExp old = RegExp(r'\([a-zA-Z0-9.]{0,20}\)');
    String group = data['group'];
    String lesson = data['data'][0].toString().replaceAll(' ', '');
    String times = data['data'][1];

    RegExpMatch? courseMatch = old.firstMatch(data['data'][3]);
    String courseOld = courseMatch != null ? courseMatch[0] ?? '' : '';
    String courseNew = (data['data'][3] as String).replaceAll(courseOld, '');

    RegExpMatch? roomMatch = old.firstMatch(_parseHtmlString(data['data'][4]));
    String roomOld = roomMatch != null ? roomMatch[0] ?? '' : '';
    String roomNew = _parseHtmlString(data['data'][4]).replaceAll(roomOld, '');

    RegExpMatch? teacherMatch = old.firstMatch(_parseHtmlString(data['data'][5]));
    String teacherOld = teacherMatch != null ? teacherMatch[0] ?? '' : '';
    String teacherNew = _parseHtmlString(data['data'][5]).replaceAll(teacherOld, '');

    String type = _parseHtmlString(data['data'][6]);
    String description = data['data'][7];
    return SubstitutionEntry(
        group: group,
        lesson: lesson,
        times: times,
        teacherNew: teacherNew,
        teacherOld: teacherOld,
        roomNew: roomNew,
        roomOld: roomOld,
        courseNew: courseNew,
        courseOld: courseOld,
        type: type,
        description: description);
  }

  @override
  Widget build(BuildContext context) {
    const double fontSize = 16;
    bool isCancelled = type == 'Entfall';
    TextStyle headerStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
    );
    TextStyle normalStyle = const TextStyle(
      fontSize: fontSize,
    );

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: Colors.green.shade300),
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(group, style: headerStyle),
              Text(type ?? '', style: headerStyle),
              Text(lesson, style: headerStyle),
            ],
          ),
          const Divider(color: Colors.black),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(teacherNew ?? '', style: TextStyle(
                    decoration: isCancelled ? TextDecoration.lineThrough : null,
                    fontWeight: teacherOld != '' ? FontWeight.bold : null,
                    fontSize: fontSize,
                  )),
                  Text(teacherOld ?? '', style: normalStyle),
                ],
              ),
              Column(
                children: [
                  Text(roomNew ?? '', style: TextStyle(
                    decoration: isCancelled ? TextDecoration.lineThrough : null,
                    fontWeight: roomOld != '' ? FontWeight.bold : null,
                    fontSize: fontSize,
                  )),
                  Text(roomOld ?? '', style: normalStyle),
                ],
              ),
              Column(
                children: [
                  Text(courseNew ?? '', style: TextStyle(
                    decoration: isCancelled ? TextDecoration.lineThrough : null,
                    fontWeight: courseOld != '' ? FontWeight.bold : null,
                    fontSize: fontSize,
                  )),
                  Text(courseOld ?? '', style: normalStyle),
                ],
              ),
            ],
          ),
          const Divider(color: Colors.black),
          Text(description ?? '', style: normalStyle),
        ],
      ),
    );
  }
}
