import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';

import 'package:dsbuntis/dsbuntis.dart' as dsb;

class SubstitutionsScreen extends StatelessWidget {
  const SubstitutionsScreen({Key? key}) : super(key: key);

  Future<void> test() async {
    final json = await dsb.getAllSubs('239601', 'a87xw9p4');
    print(json);
  }

  @override
  Widget build(BuildContext context) {



    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: MCGAppBar(
          title: "Vertretungsplan",
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_alt),
              onPressed: () {
                print("test");
                print(test());
              },
            ),
          ],
        ),
        drawer: const MCGDrawer(),
        body: const Center(
            child: Text("Vertretungsplan")
        ),
      ),
    );
  }
}
