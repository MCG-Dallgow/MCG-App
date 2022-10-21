import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:webviewx/webviewx.dart';
import 'package:dio/dio.dart';

import '../classes/substitution_entry.dart';
import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';

class SubstitutionsScreen extends StatefulWidget {
  const SubstitutionsScreen({Key? key}) : super(key: key);

  @override
  State<SubstitutionsScreen> createState() => _SubstitutionsScreenState();
}

class _SubstitutionsScreenState extends State<SubstitutionsScreen> {
  late WebViewXController webviewController;

  int maxTabBarLength = 3;
  List<Map> substitutionData = [];
  List<String> planNames = [];

  int _tabBarLength = 1;
  TabBar _tabBar = const TabBar(tabs: [Tab(child: Text('Wird geladen...'))]);
  TabBarView _tabBarView = const TabBarView(children: [Center(child: Text('Wird geladen...'))]);

  @override
  void initState() {
    initializeDateFormatting('de_DE');
    super.initState();
    _getSubstitutions();
  }

  void _getSubstitutions() async {
    var dio = Dio();

    for (int offset = 0; offset < 3; offset++) {
      DateTime now = DateTime.now();
      DateFormat format = DateFormat('yyyyMMdd');
      var response = await dio.post(
        'https://herakles.webuntis.com/WebUntis/monitor/substitution/data?school=Marie-Curie-Gym',
        data: {
          'formatName': 'Vertretungsplan DSB',
          'schoolName': 'Marie-Curie-Gym',
          'date': format.format(now),
          'dateOffset': offset,
          'strikethrough': false,
          'mergeBlocks': true,
          'showOnlyFutureSub': false,
          'showBreakSupervisions': false,
          'showTeacher': true,
          'showClass': true,
          'showHour': true,
          'showInfo': true,
          'showRoom': true,
          'showSubject': true,
          'groupBy': 1,
          'hideAbsent': false,
          'departmentIds': [],
          'departmentElementType': -1,
          'hideCancelWithSubstitution': false,
          'hideCancelCausedByEvent': false,
          'showTime': true,
          'showSubstText': true,
          'showAbsentElements': [],
          'showAffectedElements': [],
          'showUnitTime': false,
          'showMessages': true,
          'showStudentgroup': false,
          'showTeacherOnEvent': false,
          'showAbsentTeacher': true,
          'strikethroughAbsentTeacher': false,
          'activityTypeIds': [],
          'showEvent': true,
          'showCancel': true,
          'showOnlyCancel': false,
          'showSubstTypeColor': false,
          'showExamSupervision': true,
          'showUnheraldedExams': false
        },
      );

      int planDate = response.data['payload']['showingNextDate']
          ? response.data['payload']['nextDate']
          : response.data['payload']['date'];

      setState(() {
        if (substitutionData.length < maxTabBarLength && (response.data['payload']['rows'] as List).isNotEmpty) {
          substitutionData.add(response.data);
          planNames.add(_getDateFormat(planDate.toString()));
        }
      });
      _setTabBar();
    }
  }

  String _getDateFormat(String date) {
    String now = DateFormat('yyyyMMdd').format(DateTime.now());
    int nowInt = int.parse(now);
    if (date != DateFormat('yyyyMMdd').format(DateTime.parse(date))) return 'Ungültiges Datum';
    int dateInt = int.parse(date);

    if (date == now) return 'Heute';
    if (dateInt == nowInt + 1) return 'Morgen';
    if (dateInt == nowInt - 1) return 'Gestern';
    if (dateInt > nowInt && dateInt < nowInt + 7) return DateFormat('EEEE', 'de').format(DateTime.parse(date));
    return DateFormat('dd.MM.yyyy').format(DateTime.parse(date));
  }

  void _setTabBar() {
    List<Widget> tabs = [];
    for (int i = 0; i < substitutionData.length; i++) {
      if (planNames.length > i) {
        tabs.add(Tab(child: Text(planNames[i])));
      }
    }
    if (tabs.isEmpty) tabs.add(const Tab(child: Text('Wird geladen...')));

    List<Widget> tabViews = [];
    for (int i = 0; i < substitutionData.length; i++) {
      if (substitutionData.isNotEmpty && substitutionData.length > i) {}
      tabViews.add(
        ListView.builder(
          itemCount: substitutionData[i]['payload']['rows'].length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
                child: Text('Stand: ${substitutionData[i]['payload']['lastUpdate']}'),
              );
            }
            var data = substitutionData[i]['payload']['rows'][index - 1];
            return SubstitutionEntry.fromJson(data);
          },
        ),
      );
    }
    if (tabViews.isEmpty) tabViews.add(const Center(child: Text('Wird geladen...')));

    setState(() {
      _tabBar = TabBar(tabs: tabs);
      _tabBarView = TabBarView(children: tabViews);
      _tabBarLength = tabs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: _tabBarLength,
      child: Scaffold(
        appBar: MCGAppBar(
          title: 'Vertretungsplan',
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  substitutionData = [];
                });
                _getSubstitutions();
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_alt),
              onPressed: () {},
            ),
          ],
          bottom: _tabBar,
        ),
        drawer: const MCGDrawer(),
        body: _tabBarView,
      ),
    );
  }
}
