import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mcgapp/classes/user.dart';
import 'package:mcgapp/screens/auth/signin_screen.dart';
import 'package:mcgapp/screens/home_screen.dart';
import 'package:mcgapp/screens/substitutions_screen.dart';

import '../screens/grades/grades_screen.dart';
import '../screens/roomplan_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/teacher_list_screen.dart';

class MCGDrawer extends StatelessWidget {
  const MCGDrawer({
    Key? key,
    required this.routeName,
  }) : super(key: key);

  final String routeName;

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
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppUser.user.firstName} ${AppUser.user.lastName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Text(AppUser.user.email, style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: routeName == HomeScreen.routeName ? Colors.green : null,
            ),
            title: Text(
              'Home',
              style: TextStyle(color: routeName == HomeScreen.routeName ? Colors.green : null),
            ),
            onTap: () {
              if (routeName == HomeScreen.routeName) {
                Navigator.pop(context);
              } else {
                Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
              }
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.book,
              color: Colors.grey, //routeName == const TimetableScreen().routeName ? Colors.green : null,
            ),
            title: const Text(
              'Stundenplan - Coming Soon',
              style: TextStyle(
                color: Colors.grey, /*routeName == const TimetableScreen().routeName ? Colors.green : null*/
              ),
            ),
            onTap: () {
              /*if (routeName == TimetableScreen.routeName) {
                Navigator.pop(context);
              } else {
                Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                Navigator.pushNamed(context, TimetableScreen.routeName);
              }*/
            },
          ),
          ListTile(
            leading: Icon(
              Icons.calendar_today,
              color: routeName == SubstitutionsScreen.routeName ? Colors.green : null,
            ),
            title: Text(
              'Vertretungsplan',
              style: TextStyle(color: routeName == SubstitutionsScreen.routeName ? Colors.green : null),
            ),
            onTap: () {
              if (routeName == SubstitutionsScreen.routeName) {
                Navigator.pop(context);
              } else {
                Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                Navigator.pushNamed(context, SubstitutionsScreen.routeName);
              }
            },
          ),
          ListTile(
            leading: Icon(
              Icons.room_outlined,
              color: routeName == RoomplanScreen.routeName ? Colors.green : null,
            ),
            title: Text(
              'Raumplan',
              style: TextStyle(color: routeName == RoomplanScreen.routeName ? Colors.green : null),
            ),
            onTap: () {
              if (routeName == RoomplanScreen.routeName) {
                Navigator.pop(context);
              } else {
                Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                Navigator.pushNamed(context, RoomplanScreen.routeName);
              }
            },
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: routeName == TeacherListScreen.routeName ? Colors.green : null,
            ),
            title: Text(
              'Lehrerliste',
              style: TextStyle(color: routeName == TeacherListScreen.routeName ? Colors.green : null),
            ),
            onTap: () {
              if (routeName == TeacherListScreen.routeName) {
                Navigator.pop(context);
              } else {
                Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                Navigator.pushNamed(context, TeacherListScreen.routeName);
              }
            },
          ),
          ListTile(
            leading: Icon(
              Icons.star,
              color: routeName == GradesScreen.routeName ? Colors.green : null,
            ),
            title: Text(
              'Noten',
              style: TextStyle(color: routeName == GradesScreen.routeName ? Colors.green : null),
            ),
            onTap: () {
              if (routeName == GradesScreen.routeName) {
                Navigator.pop(context);
              } else {
                Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                Navigator.pushNamed(context, GradesScreen.routeName);
              }
            },
          ),
          const Divider(indent: 10, endIndent: 10, thickness: 1),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: routeName == SettingsScreen.routeName ? Colors.green : null,
            ),
            title: Text(
              'Einstellungen',
              style: TextStyle(color: routeName == SettingsScreen.routeName ? Colors.green : null),
            ),
            onTap: () {
              if (routeName == SettingsScreen.routeName) {
                Navigator.pop(context);
              } else {
                Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                Navigator.pushNamed(context, SettingsScreen.routeName);
              }
            },
          ),
          /*ListTile(
            leading: Icon(
              Icons.account_balance,
              color: routeName == CreditsScreen.routeName ? Colors.green : null,
            ),
            title: Text(
              'Credits',
              style: TextStyle(color: routeName == CreditsScreen.routeName ? Colors.green : null),
            ),
            onTap: () {
              if (routeName == CreditsScreen.routeName) {
                Navigator.pop(context);
              } else {
                Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                Navigator.pushNamed(context, CreditsScreen.routeName);
              }
            },
          ),
          const Divider(indent: 10, endIndent: 10, thickness: 1),*/
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Abmelden'),
            onTap: () {
              FirebaseAuth.instance.signOut();

              Navigator.pushNamedAndRemoveUntil(context, SignInScreen.routeName, (route) => false);
            },
          )
        ],
      ),
    );
  }
}
