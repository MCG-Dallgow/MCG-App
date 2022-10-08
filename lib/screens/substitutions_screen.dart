import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';

class SubstitutionsScreen extends StatefulWidget {
  const SubstitutionsScreen({Key? key})
      : super(key: key);

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
              icon: const Icon(Icons.refresh),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const SubstitutionsScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_alt),
              onPressed: () { },
            ),
          ],
          bottom: const TabBar(
            physics: NeverScrollableScrollPhysics(),
            tabs: [
              Tab(
                child: Text("Heute"),
              ),
              Tab(
                child: Text("Morgen"),
              ),
            ],
          ),
        ),
        drawer: const MCGDrawer(),
        body: TabBarView(
          children: [
            InteractiveViewer(
              panEnabled: false,
              child: const WebView(
                initialUrl: 'https://dsbmobile.de/data/b89afef4-8a32-4480-bef8-1c874b1d8e62/dd3fb991-2339-4fce-8a1b-afb649e2cfa5/subst_001.htm'
                ),
            ),
            InteractiveViewer(
              panEnabled: false,
              child: const WebView(
                initialUrl: 'https://dsbmobile.de/data/b89afef4-8a32-4480-bef8-1c874b1d8e62/dd3fb991-2339-4fce-8a1b-afb649e2cfa5/subst_002.htm',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
