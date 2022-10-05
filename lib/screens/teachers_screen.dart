import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mcgapp/widgets/app_bar.dart';
import 'package:mcgapp/widgets/drawer.dart';

class TeachersPage extends StatefulWidget {
  const TeachersPage({Key? key}) : super(key: key);

  @override
  State<TeachersPage> createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {
  /*
  final List<String> teachers = <String>[
    "Herr Möller",
    "Herr Sydow",
    "Frau Gatz"
  ];
  */
  List _teachers = [];

  Future<String> loadJsonData() async {
    var jsonText = await rootBundle.loadString("assets/teacher.json");
    setState(() {
      _teachers = json.decode(jsonText)["teachers"];
    });
    return "success";
  }

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

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
              onPressed: () {  },
            ),
          ],
        ),
        drawer: const MCGDrawer(),
        body: _teachers.isNotEmpty
            ? ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _teachers.length * 2,
              itemBuilder: (BuildContext context, int index) {
                if (index.isOdd) {
                  return const Divider();
                }
                return ListTile(
                  /*leading: CircleAvatar(

                  ),*/
                  title: Text("${_teachers[index ~/ 2]["anrede"]} ${_teachers[index ~/ 2]["nachname"]}"),
                  onTap: () {  },
                );
              })
          : const Center(child: Text("empty"))
      ),
    );
  }
}