import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: MCGAppBar(
            title: "MCG App",
          ),
          drawer: const MCGDrawer(),
          body: const Center(
              child: Text("Startseite")
          ),
        ),
    );
  }
}
