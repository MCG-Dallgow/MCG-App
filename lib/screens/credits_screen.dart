import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';

class Credits extends StatefulWidget {
  const Credits({Key? key}) : super(key: key);

  @override
  State<Credits> createState() => _CreditsState();
}

class _CreditsState extends State<Credits> {
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
              Text('Anna Wiedenroth'),
              Text('Cecile Mackenrotdt'),
              Text('Mathis Jasse'),
              Text('Sven Luca Hafemann'),
              Text('Denis Lomovtsev'),
              Text('Linus Wettach'),
              Text('Vincenzo Herbers'),
              Text('Luka Braunholz'),
              Text('Tim Büschner'),
              Text('Dani Badea'),
              Text('Kimi Müller'),
              Text('Lukas Löffelmann'),
              Text('Vanessa Fleck'),
              Text('Tamino Mende'),
              Text('Michael Hennig'),
              Text('Jonathan Frank'),
              Text('Lars Kuhr'),
              Text('Charlene Kühnaß'),
              Text('Viktoria Lorkowski'),
              Text('Leni Helmhart'),
            ],
          ),
        ),
      ),
    );
  }
}
