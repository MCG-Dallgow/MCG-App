import 'package:flutter/material.dart';

import '../../classes/teacher.dart';
import '../../widgets/app_bar.dart';

class TeacherDetailsScreen extends StatelessWidget {
  const TeacherDetailsScreen({Key? key}) : super(key: key);

  static const String routeName = '/teachers/details';

  @override
  Widget build(BuildContext context) {
    final teacher = ModalRoute.of(context)!.settings.arguments as Teacher;

    return Scaffold(
      appBar: MCGAppBar(
        title: Text('${teacher.title} ${teacher.lastname}'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('${teacher.firstname} ${teacher.lastname}' != ''
                ? '${teacher.firstname} ${teacher.lastname}'
                : 'kein vermerkter Name'),
            leading: const Icon(Icons.person),
          ),
          ListTile(
            title: Text(teacher.subjects.isNotEmpty
                ? teacher.subjects.map((e) => e.name).join(', ')
                : 'keine vermerkten Fächer'),
            leading: const Icon(Icons.subject),
          ),
          ListTile(
            title: Text(teacher.short != ''
                ? teacher.short
                : 'kein vermerkes Kürzel'),
            leading: const Icon(Icons.tag),
          ),
          ListTile(
            title: Text(teacher.email != ''
                ? teacher.email
                : 'keine vermerkte E-Mail-Adresse'),
            leading: const Icon(Icons.email),
          )
        ],
      ),
    );
  }
}

class SekretariatScreen extends StatelessWidget {
  const SekretariatScreen({Key? key}) : super(key: key);

  static const String routeName = '/teachers/office';

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as List<String>;

    return Scaffold(
      appBar: MCGAppBar(
        title: const Text('Sekretariat'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(data[0]),
            leading: const Icon(Icons.email),
          ),
          ListTile(
            title: Text(data[1]),
            leading: const Icon(Icons.phone),
          ),
        ],
      ),
    );
  }
}