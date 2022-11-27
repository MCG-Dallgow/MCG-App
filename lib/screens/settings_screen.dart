import 'package:flutter/material.dart';
import 'package:mcgapp/widgets/course_dialog.dart';
import '../classes/course.dart';
import '../main.dart';

import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';
import '../widgets/group_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static const String routeName = '/settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MCGAppBar(title: const Text('Einstellungen')),
      drawer: const MCGDrawer(routeName: SettingsScreen.routeName),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Dark Mode'),
            leading: const Icon(Icons.brightness_2),
            trailing: Switch(
              value: themeManager.themeMode == ThemeMode.dark,
              onChanged: (newValue) {
                setState(() {
                  themeManager.toggleTheme(newValue);
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Klasse/Tutoriat wählen'),
            leading: const Icon(Icons.tag),
            onTap: () async {
              await chooseGroup(context, true);
              if (!mounted) return;
              if (userCourses.isEmpty) await chooseCourses(context);
            },
          ),
          ListTile(
            title: const Text('Kurse wählen'),
            leading: const Icon(Icons.school),
            onTap: () async {
              await chooseCourses(context);
            },
          ),
        ],
      ),
    );
  }
}
