import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';

class CreditsScreen extends StatefulWidget {
  const CreditsScreen({Key? key}) : super(key: key);

  @override
  State<CreditsScreen> createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: MCGAppBar(
          title: "Credits",
        ),
        drawer: const MCGDrawer(),
        body: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(32, 32, 32, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Text('Programmierer:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Sven Luca Hafemann', style: TextStyle(fontSize: 16)),
              Text('Tamino Mende', style: TextStyle(fontSize: 16)),
              Text('Denis Lomovtsev', style: TextStyle(fontSize: 16)),
              Text('Lukas Löffelmann', style: TextStyle(fontSize: 16)),
              Text('Lars Kuhr', style: TextStyle(fontSize: 16)),
              Text(''),
              Text('Rauminformationen:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Mathis Jasse', style: TextStyle(fontSize: 16)),
              Text('Leni Helmhart', style: TextStyle(fontSize: 16)),
              Text('Charlene Kühnaß', style: TextStyle(fontSize: 16)),
              Text('Vincenzo Herbers', style: TextStyle(fontSize: 16)),
              Text(''),
              Text('Design:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Tim Püschner', style: TextStyle(fontSize: 16)),
              Text('Dani Badea', style: TextStyle(fontSize: 16)),
              Text('Kimi Müller', style: TextStyle(fontSize: 16)),
              Text('Michael Hennig', style: TextStyle(fontSize: 16)),
              Text('Jonathan Frank', style: TextStyle(fontSize: 16)),
              Text(''),
              Text('Digitalisierung der Karte:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Linus Wettach', style: TextStyle(fontSize: 16)),
              Text('Luka Braunholz', style: TextStyle(fontSize: 16)),
              Text('Vanessa Fleck', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
