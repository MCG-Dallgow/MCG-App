import 'package:flutter/material.dart';
import 'package:mcgapp/widgets/app_bar.dart';

import '../classes/teacher.dart';

class TeacherDetails extends StatefulWidget {
  const TeacherDetails({
    Key? key,
    required this.teacher,
  }) : super(key: key);

  final Teacher teacher;

  @override
  State<TeacherDetails> createState() => _TeacherDetailsState();
}

class _TeacherDetailsState extends State<TeacherDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MCGAppBar(title: "${widget.teacher.anrede} ${widget.teacher.nachname}",),
      body: ListView(
        children: [
          ListTile(
            title: Text("${widget.teacher.vorname} ${widget.teacher.nachname}"),
            leading: const Icon(Icons.person),
          ),
          ListTile(
            title: Text(widget.teacher.faecher),
            leading: const Icon(Icons.subject),
          ),
          ListTile(
            title: Text(widget.teacher.kuerzel),
            leading: const Icon(Icons.tag),
          ),
          ListTile(
            title: Text(widget.teacher.email),
            leading: const Icon(Icons.email),
          )
        ],
      ),
    );
  }
}
