import 'package:flutter/material.dart';
import '../main.dart';

import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static const String routeName = '/settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MCGAppBar(title: const Text('Einstellungen')),
      drawer: const MCGDrawer(routeName: SettingsScreen.routeName),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: themeManager.themeMode == ThemeMode.dark,
              onChanged: (newValue) {
                setState(() {
                  themeManager.toggleTheme(newValue);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
