import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:mcgapp/main.dart';

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
  final String lesson; // Schulstunde ('3-4' -> 2. Block)
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

  static String _parseLesson(String lesson) {
    switch (lesson) {
      case '1-2':
      case '1':
      case '2':
        return '1. Block';
      case '3-4':
      case '3':
      case '4':
        return '2. Block';
      case '4-6':
      case '5-6':
      case '5':
      case '6':
        return '3. Block';
      case '7-8':
      case '7':
      case '8':
        return '4. Block';
      default:
        return 'Fehler';
    }
  }

  static String _parseRoom(String room) {
    room = room.replaceAll('(', '').replaceAll(')', '').trim();

    RegExp regex = RegExp(r'[0-9]{3}');
    Iterable<RegExpMatch?> matches = regex.allMatches(room);

    for (RegExpMatch? match in matches) {
      if (match != null) {
        room = room.replaceAll(room, '${room[0]}.${room.substring(1)}');
      }
    }
    return room;
  }

  factory SubstitutionEntry.fromJson(var data) {
    RegExp old = RegExp(r'\([a-zA-Z0-9.-]{0,20}\)');
    String group = data['group'];
    String lesson = _parseLesson(data['data'][0].toString().replaceAll(' ', ''));
    String times = data['data'][1];

    RegExpMatch? courseMatch = old.firstMatch(data['data'][3]);
    String courseOld = courseMatch != null ? courseMatch[0] ?? '' : '';
    String courseNew = (data['data'][3] as String).replaceAll(courseOld, '');

    RegExpMatch? roomMatch = old.firstMatch(_parseHtmlString(data['data'][4]));
    String roomOld = roomMatch != null ? roomMatch[0] ?? '' : '';
    String roomNew = _parseRoom(_parseHtmlString(data['data'][4]).replaceAll(roomOld, ''));
    roomOld = _parseRoom(roomOld);

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

    return Card(
      color: isCancelled ? themeManager.colorCancelled : themeManager.colorSecondary,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    group,
                    style: headerStyle,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Text(
                    type ?? '',
                    style: headerStyle,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Text(
                    lesson,
                    style: headerStyle,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Divider(color: themeManager.colorStroke),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          (teacherNew ?? '').startsWith('(')
                              ? (teacherNew ?? '').replaceAll('(', '').replaceAll(')', '').trim()
                              : teacherNew ?? '',
                          style: TextStyle(
                            decoration:
                                isCancelled | (teacherNew ?? '').startsWith('(') ? TextDecoration.lineThrough : null,
                            fontWeight: teacherOld != '' ? FontWeight.bold : null,
                            fontSize: fontSize,
                          ),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          (teacherOld ?? '').startsWith('(')
                              ? (teacherOld ?? '').replaceAll('(', '').replaceAll(')', '').trim()
                              : teacherOld ?? '',
                          style: (teacherOld ?? '').startsWith('(')
                              ? const TextStyle(fontSize: fontSize, decoration: TextDecoration.lineThrough)
                              : normalStyle,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        roomNew ?? '',
                        style: TextStyle(
                          decoration: isCancelled ? TextDecoration.lineThrough : null,
                          fontWeight: roomOld != '' ? FontWeight.bold : null,
                          fontSize: fontSize,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        roomOld ?? '',
                        style: roomNew == ''
                            ? normalStyle
                            : const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: fontSize,
                              ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          courseNew ?? '',
                          style: TextStyle(
                            decoration: isCancelled ? TextDecoration.lineThrough : null,
                            fontWeight: courseOld != '' ? FontWeight.bold : null,
                            fontSize: fontSize,
                          ),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          courseOld ?? '',
                          style: normalStyle,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            (description ?? '') == ''
                ? Container()
                : Column(
                    children: [
                      Divider(color: themeManager.colorStroke),
                      Text(description ?? '', style: normalStyle),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
