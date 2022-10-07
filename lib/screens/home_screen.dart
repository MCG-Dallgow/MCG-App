import 'package:flutter/material.dart';

import '../widgets/drawer.dart';
import '../widgets/app_bar.dart';

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
        body: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/mcg_seite.jpg',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/images/mcg_logo.png',
                    height: 100,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Image.asset(
              'assets/images/mcg_oben.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
