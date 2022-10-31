import 'package:flutter/material.dart';
import 'package:mcgapp/screens/roomplan_screen.dart';
import 'package:mcgapp/screens/settings_screen.dart';
import 'package:mcgapp/screens/substitutions_screen.dart';
import 'package:mcgapp/screens/teacher_list_screen.dart';
import 'package:mcgapp/screens/credits_screen.dart';

import '../screens/home_screen.dart';

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
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const HomeScreen();
                  }),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.book, color: Colors.grey,),
            title: const Text('Stundenplan - Coming Soon', style: TextStyle(color: Colors.grey)),
            onTap: () {
              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const TimetableScreen();
                }),
              );*/
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Vertretungsplan'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const SubstitutionsScreen();
                }),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.room_outlined),
            title: const Text('Raumplan'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const RoomplanScreen();
                }),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Lehrerliste'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const TeacherListScreen();
                }),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.star, color: Colors.grey,),
            title: const Text('Noten - Coming Soon', style: TextStyle(color: Colors.grey)),
            onTap: () {},
          ),
          const Divider(
            color:Colors.black38,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Einstellungen'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const SettingsScreen();
                }),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: const Text('Credits'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const CreditsScreen();
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}
