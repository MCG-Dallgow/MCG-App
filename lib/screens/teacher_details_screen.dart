import 'package:flutter/material.dart';
import 'package:mcgapp/widgets/app_bar.dart';

import '../classes/teacher.dart';

class TeacherDetailsScreen extends StatelessWidget {
  const TeacherDetailsScreen({
    Key? key,
    required this.teacher,
  }) : super(key: key);

  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MCGAppBar(
        title: "${teacher.anrede} ${teacher.nachname}",
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("${teacher.vorname} ${teacher.nachname}" != ""
                ? "${teacher.vorname} ${teacher.nachname}"
                : "kein vermerkter Name"),
            leading: const Icon(Icons.person),
          ),
          ListTile(
            title: Text(teacher.faecher != ""
                ? teacher.faecher
                : "keine vermerkten Fächer"),
            leading: const Icon(Icons.subject),
          ),
          ListTile(
            title: Text(teacher.kuerzel != ""
                ? teacher.kuerzel
                : "kein vermerkes Kürzel"),
            leading: const Icon(Icons.tag),
          ),
          ListTile(
            title: Text(teacher.email != ""
                ? teacher.email
                : "keine vermerkte E-Mail-Adresse"),
            leading: const Icon(Icons.email),
          )
        ],
      ),
    );
  }
}
