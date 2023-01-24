import 'package:flutter/material.dart';
import 'package:mcgapp/main.dart';

import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MCGAppBar(title: Text(appName)),
      drawer: const MCGDrawer(routeName: routeName),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/images/mcg-panorama.jpg',
              width: 50,
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
              'Derzeitige Features:\n\u2022 Timeline\n\u2022 Stundenplan (aktuell nur für einige Klassen verfügbar)'
              '\n\u2022 Vertretungsplan\n\u2022 Raumplan\n\u2022 Lehrerliste\n\u2022 Notenübersicht',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
