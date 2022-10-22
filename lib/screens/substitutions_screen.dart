import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/substitution_entry.dart';
import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';

class SubstitutionsScreen extends StatefulWidget {
  const SubstitutionsScreen({Key? key}) : super(key: key);

  @override
  State<SubstitutionsScreen> createState() => _SubstitutionsScreenState();
}

class _SubstitutionsScreenState extends State<SubstitutionsScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final int _maxTabBarLength = 3;
  List<Map> _substitutionData = [];
  List<String> _planNames = [];

  int _tabBarLength = 1;
  TabBar _tabBar = const TabBar(tabs: [Tab(child: Text('Wird geladen...'))]);
  TabBarView _tabBarView = const TabBarView(children: [Center(child: Text('Wird geladen...'))]);

  String _groupFilter = '';
  List<String> _courseFilter = [];
  String _teacherFilter = '';

  @override
  void initState() {
    initializeDateFormatting('de_DE');
    super.initState();
    _getSubstitutions();
  }

  void _getSubstitutions() async {
    setState(() {
      _substitutionData = [];
      _planNames = [];
    });

    var dio = Dio();
    for (int offset = 0; offset < 3; offset++) {
      DateTime now = DateTime.now();
      DateFormat format = DateFormat('yyyyMMdd');
      var response = await dio.post(
        'https://herakles.webuntis.com/WebUntis/monitor/substitution/data?school=Marie-Curie-Gym',
        data: {
          'formatName': 'Vertretungsplan DSB',
          'schoolName': 'Marie-Curie-Gym',
          'date': int.parse(format.format(now)),
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
        if (_substitutionData.length < _maxTabBarLength && (response.data['payload']['rows'] as List).isNotEmpty) {
          _substitutionData.add(response.data);
          _planNames.add(_getDateFormat(planDate.toString()));
        }
      });
      _loadFilters();
      _setTabBar();
    }
  }

  Future<void> _saveFilters() async {
    SharedPreferences prefs = await _prefs;

    prefs.setString('groupFilter', _groupFilter);
    prefs.setStringList('courseFilter', _courseFilter);
    prefs.setString('teacherFilter', _teacherFilter);
  }

  Future<void> _loadFilters() async {
    SharedPreferences prefs = await _prefs;

    setState(() {
      _groupFilter = prefs.getString('groupFilter') ?? '';
      _courseFilter = prefs.getStringList('courseFilter') ?? [];
      _teacherFilter = prefs.getString('teacherFilter') ?? '';
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

  void _setTabBar() {
    List<Widget> tabs = [];
    for (int i = 0; i < _substitutionData.length; i++) {
      tabs.add(Tab(child: Text(_planNames[i])));
    }
    if (tabs.isEmpty) tabs.add(const Tab(child: Text('Wird geladen...')));

    setState(() {
      _tabBar = TabBar(tabs: tabs);
      _tabBarLength = tabs.length;
    });
    _updateTabViews();
  }

  void _updateTabViews() {
    List<Widget> tabViews = [];
    for (int i = 0; i < _substitutionData.length; i++) {
      List<SubstitutionEntry> unfilteredEntries = [];
      List<SubstitutionEntry> filteredEntries = [];

      for (int j = 0; j < (_substitutionData[i]['payload']['rows'] as List).length; j++) {
        unfilteredEntries.add(SubstitutionEntry.fromJson(_substitutionData[i]['payload']['rows'][j]));
      }

      for (SubstitutionEntry entry in unfilteredEntries) {
        if ((_groupFilter == '' && _courseFilter.isEmpty && _teacherFilter == '') ||
            (_groupFilter != '' && entry.group.toLowerCase().contains(_groupFilter.toLowerCase())) ||
            (_courseFilter.isNotEmpty &&
                (entry.courseNew != '' && _courseFilter.contains(entry.courseNew) ||
                    entry.courseOld != '' && _courseFilter.contains(entry.courseOld))) ||
            (_teacherFilter != '' && (entry.teacherNew == _teacherFilter || entry.teacherOld == _teacherFilter))) {
          filteredEntries.add(entry);
        }
      }

      tabViews.add(
        ListView.builder(
          itemCount: filteredEntries.isEmpty ? 2 : filteredEntries.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
                child: Text('Stand: ${_substitutionData[i]['payload']['lastUpdate']}'),
              );
            }
            if (filteredEntries.isNotEmpty) {
              return filteredEntries[index - 1];
            } else {
              return const Center(child: Text('Keine Ergebnisse für die ausgewählten Filter'));
            }
          },
        ),
      );
    }
    if (tabViews.isEmpty) tabViews.add(const Center(child: Text('Wird geladen...')));

    setState(() {
      _tabBarView = TabBarView(children: tabViews);
    });
  }

  Future<void> _showFilterDialog(BuildContext context) {
    TextEditingController groupFilterController = TextEditingController();
    groupFilterController.text = _groupFilter;

    TextEditingController courseFilterController = TextEditingController();
    courseFilterController.text = _courseFilter.join(' ');

    TextEditingController teacherFilterController = TextEditingController();
    teacherFilterController.text = _teacherFilter;

    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Ergebnisse filtern'),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Klasse oder Klassenstufe',
                  ),
                  controller: groupFilterController,
                  onChanged: (text) {
                    setState(() {
                      _groupFilter = text.trim();
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Kurse oder Fächer',
                  ),
                  controller: courseFilterController,
                  onChanged: (text) {
                    setState(() {
                      _courseFilter = text.trim().split(' ');
                    });
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text('Mehrere durch Leerzeichen trennen'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Lehrer',
                  ),
                  controller: teacherFilterController,
                  onChanged: (text) {
                    setState(() {
                      _teacherFilter = teacherFilterController.text.trim();
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton(
                  onPressed: () {
                    _saveFilters();
                    _updateTabViews();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Speichern'),
                ),
              ),
            ],
          );
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
            IconButton(icon: const Icon(Icons.refresh), onPressed: () => _getSubstitutions()),
            IconButton(icon: const Icon(Icons.filter_alt), onPressed: () => _showFilterDialog(context)),
          ],
          bottom: _tabBar,
        ),
        drawer: const MCGDrawer(),
        body: _tabBarView,
      ),
    );
  }
}
