import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';

class SubstitutionsScreen extends StatefulWidget {
  const SubstitutionsScreen({Key? key}) : super(key: key);

  @override
  State<SubstitutionsScreen> createState() => _SubstitutionsScreenState();
}

class _SubstitutionsScreenState extends State<SubstitutionsScreen> {

  @override
  void initState() {
    super.initState();
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
                //connect();
              },
            ),
          ],
        ),
        drawer: const MCGDrawer(),
        body: InteractiveViewer(
          maxScale: 4,
          child: Container(
            alignment: Alignment.topCenter,
            constraints: const BoxConstraints.expand(),
            child: Image.asset('assets/images/substitution_plan.jpg'),
          )
        )
      ),
    );
  }
}
