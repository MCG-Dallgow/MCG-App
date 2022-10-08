import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:dsb/dsb.dart';

import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';

class SubstitutionsScreen extends StatefulWidget {
  const SubstitutionsScreen({Key? key})
      : super(key: key);

  @override
  State<SubstitutionsScreen> createState() => _SubstitutionsScreenState();
}

class _SubstitutionsScreenState extends State<SubstitutionsScreen> {

  final List<String> substitutionURIs = ["", ""];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getSubstitutionsURI();
  }

  Future<void> _getSubstitutionsURI() async {
    final session = Session('b89afef4-8a32-4480-bef8-1c874b1d8e62');
    final jsonText = await session.getTimetablesJsonString();
    final data = json.decode(jsonText);
    setState(() {
      substitutionURIs.insert(0, data[1]['Childs'][0]['Detail']);
      substitutionURIs.insert(1, data[1]['Childs'][1]['Detail']);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: MCGAppBar(
          title: 'Vertretungsplan',
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
                child: Text("Plan 1"),
              ),
              Tab(
                child: Text("Plan 2"),
              ),
            ],
          ),
        ),
        drawer: const MCGDrawer(),
        body: TabBarView(
          children: [
            InteractiveViewer(
              panEnabled: false,
              child: isLoading
                  ? const Center(child: Text('Wird geladen...'))
                  : WebView(initialUrl: substitutionURIs[0]),
            ),
            InteractiveViewer(
              panEnabled: false,
              child: isLoading
                  ? const Center(child: Text('Wird geladen...'))
                  : WebView(initialUrl: substitutionURIs[1]),
            ),
          ],
        ),
      ),
    );
  }
}
