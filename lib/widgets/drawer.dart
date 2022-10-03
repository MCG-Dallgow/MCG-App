import 'package:flutter/material.dart';
import 'package:mcgapp/pages/roomplan_page.dart';
import 'package:mcgapp/pages/substitution_page.dart';

import '../pages/home_page.dart';
import '../pages/timetable_page.dart';

class MCGDrawer extends StatelessWidget {
  const MCGDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Text(
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
        ],
      ),
    );
  }
}
