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

  List<Map> substitutionData = [{}, {}, {}];
  int length = 3;
  String plan1Name = 'Plan 1';
  String plan2Name = 'Plan 2';
  String plan3Name = 'Plan 3';

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
          'dateOffset': now.hour < 12 || now.minute == 0 ? offset : offset-1,
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
          'enableSubstitutionFrom': true,
          'showSubstitutionFrom': 1200,
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
      setState(() {
        substitutionData.insert(offset, response.data);
      });
    }
    setState(() {
      plan1Name = _getDateFormat(substitutionData[0]['payload']['nextDate'].toString());
      plan2Name = _getDateFormat(substitutionData[1]['payload']['nextDate'].toString());
      plan3Name = _getDateFormat(substitutionData[2]['payload']['nextDate'].toString());
    });
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: MCGAppBar(
          title: 'Vertretungsplan',
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  substitutionData = [{}, {}, {}];
                  plan1Name = 'Plan 1';
                  plan2Name = 'Plan 2';
                  plan3Name = 'Plan 3';
                });
                _getSubstitutions();
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_alt),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(plan1Name),
              ),
              Tab(
                child: Text(plan2Name),
              ),
              Tab(
                child: Text(plan3Name),
              )
            ],
          ),
        ),
        drawer: const MCGDrawer(),
        body: TabBarView(
          children: [
            substitutionData[0].isEmpty
                ? const Center(child: Text('Wird geladen...'))
                : ListView.builder(
                    itemCount: substitutionData[0]['payload']['rows'].length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 5.0, bottom: 5.0),
                          child: Text('Stand: ${substitutionData[0]['payload']['lastUpdate']}'),
                        );
                      }
                      var data = substitutionData[0]['payload']['rows'][index - 1];
                      return SubstitutionEntry.fromJson(data);
                    },
                  ),
            substitutionData[1].isEmpty
                ? const Center(child: Text('Wird geladen...'))
                : ListView.builder(
              itemCount: substitutionData[1]['payload']['rows'].length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 5.0, bottom: 5.0),
                    child: Text('Stand: ${substitutionData[1]['payload']['lastUpdate']}'),
                  );
                }
                var data = substitutionData[1]['payload']['rows'][index - 1];
                return SubstitutionEntry.fromJson(data);
              },
            ),
            substitutionData[2].isEmpty
                ? const Center(child: Text('Wird geladen...'))
                : ListView.builder(
              itemCount: substitutionData[2]['payload']['rows'].length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 5.0, bottom: 5.0),
                    child: Text('Stand: ${substitutionData[2]['payload']['lastUpdate']}'),
                  );
                }
                var data = substitutionData[2]['payload']['rows'][index - 1];
                return SubstitutionEntry.fromJson(data);
              },
            ),
          ],
        ),
      ),
    );
  }
}
