import 'package:flutter/material.dart';
import '../main.dart';

import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: MCGAppBar(
          title: "Einstellungen",
        ),
        drawer: const MCGDrawer(),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: const Text("Dark Mode"),
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
      ),
    );
  }
}
