import 'package:flutter/material.dart';

import '../widgets/drawer.dart';
import '../widgets/app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MCGAppBar(
        title: "MCG App",
      ),
      drawer: const MCGDrawer(routeName: HomeScreen.routeName),
      body: ListView(
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/images/mcg_seite.jpg',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  'assets/images/mcg_logo.png',
                  height: 100,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: Text(
              'Eine App, die Schülern des Marie-Curie-Gymnasiums Dallgow-Döberitz in ihrem Alltag hilft.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'Diese App ist während der Projektwoche zum 20. Jahrestag des Marie-Curie-Gymnasiums erstellt worden, wird jedoch in Zukunft weiterentwickelt werden.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: Text(
              'Derzeitige Features: Vertretungsplan, Raumplan, Lehrerliste',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Image.asset(
            'assets/images/mcg_oben.jpg',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
