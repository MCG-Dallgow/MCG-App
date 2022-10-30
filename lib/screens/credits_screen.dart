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
          padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Text('Projektleitung', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Sven Luca Hafemann', style: TextStyle(fontSize: 16)),
              Text(''),
              Text('Programmierung', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Sven Luca Hafemann', style: TextStyle(fontSize: 16)),
              Text('Tamino Mende', style: TextStyle(fontSize: 16)),
              Text('Lukas Löffelmann', style: TextStyle(fontSize: 16)),
              Text(''),
              Text('Digitalisierung des Raumplans', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Linus Wettach', style: TextStyle(fontSize: 16)),
              Text('Lars Kuhr', style: TextStyle(fontSize: 16)),
              Text('Luka Braunholz', style: TextStyle(fontSize: 16)),
              Text(''),
              Text('Informationsbeschaffung', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Michael Hennig', style: TextStyle(fontSize: 16)),
              Text('Lukas Löffelmann', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
