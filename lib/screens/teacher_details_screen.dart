import 'package:flutter/material.dart';
import 'package:mcgapp/widgets/app_bar.dart';

import '../classes/teacher.dart';

class TeacherDetailsScreen extends StatefulWidget {
  const TeacherDetailsScreen({
    Key? key,
    required this.teacher,
  }) : super(key: key);

  final Teacher teacher;

  @override
  State<TeacherDetailsScreen> createState() => _TeacherDetailsScreenState();
}

class _TeacherDetailsScreenState extends State<TeacherDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MCGAppBar(
        title: "${widget.teacher.anrede} ${widget.teacher.nachname}",
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("${widget.teacher.vorname} ${widget.teacher.nachname}" != ""
                ? "${widget.teacher.vorname} ${widget.teacher.nachname}"
                : "kein vermerkter Name"),
            leading: const Icon(Icons.person),
          ),
          ListTile(
            title: Text(widget.teacher.faecher != ""
                ? widget.teacher.faecher
                : "keine vermerkten Fächer"),
            leading: const Icon(Icons.subject),
          ),
          ListTile(
            title: Text(widget.teacher.kuerzel != ""
                ? widget.teacher.kuerzel
                : "kein vermerkes Kürzel"),
            leading: const Icon(Icons.tag),
          ),
          ListTile(
            title: Text(widget.teacher.email != ""
                ? widget.teacher.email
                : "keine vermerkte E-Mail-Adresse"),
            leading: const Icon(Icons.email),
          )
        ],
      ),
    );
  }
}
