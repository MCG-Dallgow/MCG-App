import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';

class CreditsScreen extends StatefulWidget {
  const CreditsScreen({Key? key}) : super(key: key);

  static const String routeName = '/credits';

  @override
  State<CreditsScreen> createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen> {
  final TextStyle _normalStyle = const TextStyle(fontSize: 16);
  final TextStyle _headlineStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MCGAppBar(title: const Text('Credits')),
      drawer: const MCGDrawer(routeName: CreditsScreen.routeName),
      body: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Projektleitung', style: _headlineStyle),
            Text(
              '\u2022 Sven Luca Hafemann\n',
              style: _normalStyle,
            ),
            Text('Programmierung', style: _headlineStyle),
            Text(
              '\u2022 Sven Luca Hafemann\n'
              '\u2022 Tamino Mende\n'
              '\u2022 Lukas Löffelmann\n',
              style: _normalStyle,
            ),
            Text('Digitalisierung des Raumplans', style: _headlineStyle),
            Text(
              '\u2022 Linus Wettach\n'
              '\u2022 Lars Kuhr\n'
              '\u2022 Luka Braunholz\n',
              style: _normalStyle,
            ),
            Text('Informationsbeschaffung', style: _headlineStyle),
            Text(
              '\u2022 Michael Hennig\n'
              '\u2022 Lukas Löffelmann\n',
              style: _normalStyle,
            ),
          ],
        ),
      ),
    );
  }
}
