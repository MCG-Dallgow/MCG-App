import 'package:flutter/material.dart';
import '../main.dart';

import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: MCGAppBar(
          title: "Einstellungen",
          /*actions: [
            Switch(value: themeManager.themeMode == ThemeMode.dark, onChanged: (newValue) {
              setState(() {
                themeManager.toggleTheme(newValue);
              });
            }),
          ],*/
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
                    }),
              ),
            ],
          ),
      ),
    );
  }
}
