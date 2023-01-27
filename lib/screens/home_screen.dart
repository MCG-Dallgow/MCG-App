import 'package:flutter/material.dart';
import 'package:mcgapp/classes/course.dart';
import 'package:mcgapp/main.dart';
import 'package:mcgapp/widgets/course_dialog.dart';
import 'package:mcgapp/widgets/group_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/group.dart';
import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

Future checkForUpdates() async {
  var url = 'https://api.github.com/repos/MCG-App/MCG-App/releases/latest';
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    var latestRelease = jsonResponse['latest'];
    // TODO: Hier muss noch die aktuelle Version der App abgefragt werden
    var currentVersion = 'CURRENT_APP_VERSION';
    if (latestRelease != currentVersion) {
      var updateAvailable = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Neues Update verfügbar!"),
            content: Text("Eine neue Version der App ist verfügbar. Möchtest du jetzt aktualisieren? "),
            actions: <Widget>[
              FlatButton(
                child: Text("Jetzt Updaten"),
                onPressed: () => Navigator.of(context).pop(true),
              ),
              FlatButton(
                child: Text("Später"),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          );
        },
      );


      if (updateAvailable) {
        // Perform update
        var url = 'https://github.com/MCG-App/MCG-App/releases/latest';
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      }
    }
  } else {
    throw Exception('Die Suche nach Updates ist fehlgeschlagen');
  }
  

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('group') != null) group = Group.fromName(prefs.getString('group')!);

      if (!mounted) return;
      await chooseGroup(context, false);
      if (!mounted) return;
      if (userCourses.isEmpty) await chooseCourses(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MCGAppBar(title: Text(appName)),
      drawer: const MCGDrawer(routeName: HomeScreen.routeName),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/images/mcg-panorama.jpg',
              width: 50,
              //fit: BoxFit.cover,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: Text(
              'Eine App, die Schülern des Marie-Curie-Gymnasiums Dallgow-Döberitz ihren Alltag erleichtert.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'Diese App wurde in der Projektwoche zum 20. Jahrestag des Marie-Curie-Gymnasiums erstellt und wird '
              'seitdem aktiv weiterentwickelt.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: Text(
              'Derzeitige Features:\n\u2022 Stundenplan\n\u2022 Vertretungsplan\n\u2022 Raumplan\n\u2022 Lehrerliste'
              '\n\u2022 Notenübersicht',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
