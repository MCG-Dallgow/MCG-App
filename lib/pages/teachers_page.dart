import 'package:flutter/material.dart';
import 'package:mcgapp/widgets/app_bar.dart';
import 'package:mcgapp/widgets/drawer.dart';

class TeachersPage extends StatelessWidget {
  TeachersPage({Key? key}) : super(key: key);

  final List<String> teachers = <String>[
    "Herr Möller",
    "Herr Sydow",
    "Frau Gatz"
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: MCGAppBar(
          title: "Lehrerliste",
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () { },
            ),
          ],
        ),
        drawer: const MCGDrawer(),
        body: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: teachers.length * 2,
            itemBuilder: (BuildContext context, int index) {
              if (index.isOdd) {
                return const Divider();
              }
              return ListTile(
                title: Text(teachers[index ~/ 2]),
                onTap: () {  },
              );
            }),
      ),
    );
  }
}
