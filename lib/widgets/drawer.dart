import 'package:flutter/material.dart';
import 'package:mcgapp/screens/roomplan_screen.dart';
import 'package:mcgapp/screens/substitutions_screen.dart';
import 'package:mcgapp/screens/teachers_screen.dart';

import '../screens/home_screen.dart';
import '../screens/timetable_screen.dart';

class MCGDrawer extends StatelessWidget {
  const MCGDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Text(
                'MCG App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              )
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const Home();
                  }),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Stundenplan'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const Timetable();
                }),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Vertretungsplan'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const SubstitutionPlan();
                }),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.room_outlined),
            title: const Text('Raumplan'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const RoomPlan();
                }),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Lehrerliste'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const TeachersPage();
                }),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Einstellungen'),
            onTap: () {
              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return TeachersPage();
                }),
              );*/
            },
          ),
        ],
      ),
    );
  }
}
