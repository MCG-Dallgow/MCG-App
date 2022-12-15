import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mcgapp/main.dart';
import 'package:mcgapp/classes/user.dart';
import 'package:mcgapp/screens/auth/signin_screen.dart';
import 'package:mcgapp/screens/home_screen.dart';
import 'package:mcgapp/screens/substitutions_screen.dart';

import '../screens/credits_screen.dart';
import '../screens/grades/grades_screen.dart';
import '../screens/roomplan_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/teachers/teachers_screen.dart';
import '../screens/timeline_screen.dart';
import '../screens/timetable_screen.dart';

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
          SizedBox(
            height: 150,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: CircleAvatar(
                      foregroundImage: AssetImage('assets/images/mcg-icon.jpg'),
                      radius: 35,
                    ),
                  ),
                  Column(
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
            leading: Icon(
              Icons.timeline,
              color: routeName == TimelineScreen.routeName ? Colors.green : null,
            ),
            title: Text(
              'Timeline',
              style: TextStyle(color: routeName == TimelineScreen.routeName ? Colors.green : null),
            ),
            onTap: () {
              if (routeName == TimelineScreen.routeName) {
                Navigator.pop(context);
              } else {
                Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                Navigator.pushNamed(context, TimelineScreen.routeName);
              }
            },
          ),
          ListTile(
            leading: Icon(
              Icons.calendar_month,
              color: routeName == TimetableScreen.routeName ? Colors.green : null,
            ),
            title: Text(
              'Stundenplan',
              style: TextStyle(color: routeName == TimetableScreen.routeName ? Colors.green : null),
            ),
            onTap: () {
              if (routeName == TimetableScreen.routeName) {
                Navigator.pop(context);
              } else {
                Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                Navigator.pushNamed(context, TimetableScreen.routeName);
              }
            },
          ),
          ListTile(
            leading: Icon(
              Icons.edit_calendar,
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
              Icons.room,
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
              color: routeName == TeachersScreen.routeName ? Colors.green : null,
            ),
            title: Text(
              'Lehrer',
              style: TextStyle(color: routeName == TeachersScreen.routeName ? Colors.green : null),
            ),
            onTap: () {
              if (routeName == TeachersScreen.routeName) {
                Navigator.pop(context);
              } else {
                Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                Navigator.pushNamed(context, TeachersScreen.routeName);
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
          ListTile(
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
          AboutListTile(
            icon: const Icon(Icons.info),
            applicationName: appName,
            applicationVersion: appVersion,
            applicationLegalese: 'Sven Luca Hafemann',
            applicationIcon: const CircleAvatar(foregroundImage: AssetImage('assets/images/mcg-icon.jpg'), radius: 35),
            aboutBoxChildren: const [
              Text(
                '\nDiese App wurde nicht von der Schulleitung des Marie-Curie-Gymnasiums Dallgow-Döberitz in Auftrag '
                'gegeben und wird nicht von ihr betreut. Die Schulleitung ist in keiner Weise für jegliche sich aus '
                'der Veröffentlichung sowie der Verwendung ergebende Folgen verantwortlich.\n\n'
                'Die Nutzung der App erfolgt auf eigene Gefahr und Verantwortung. Es besteht keinerlei Garantie auf '
                'Richtigkeit, Vollständigkeit oder Verfügbarkeit der angezeigten Informationen in allen derzeitigen '
                'und künftigen Elementen dieser App. Dies trifft unter Anderem auf den Stundenplan, den '
                'Vertretungsplan, den Raumplan, die Lehrerliste und jegliche Funktionen der Notenübersicht zu.\n\n'
                'Diese App ist unter der GNU General Public Licence v3.0 lizenziert.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
            child: Text('Über $appName'),
          ),
          const Divider(indent: 10, endIndent: 10, thickness: 1),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Abmelden'),
            onTap: () {
              FirebaseAuth.instance.signOut();

              Navigator.pushNamedAndRemoveUntil(context, SignInScreen.routeName, (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
