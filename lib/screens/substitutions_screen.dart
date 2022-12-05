import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:mcgapp/classes/course.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/substitution_entry.dart';
import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';

class SubstitutionsScreen extends StatefulWidget {
  const SubstitutionsScreen({Key? key}) : super(key: key);

  static const String routeName = '/substitutions';

  @override
  State<SubstitutionsScreen> createState() => _SubstitutionsScreenState();
}

class _SubstitutionsScreenState extends State<SubstitutionsScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final int _maxTabBarLength = 5;
  List<Map> _substitutionData = [];
  List<String> _planNames = [];

  int _tabBarLength = 1;
  TabBar _tabBar = const TabBar(tabs: [Tab(child: Text('Wird geladen...'))]);
  TabBarView _tabBarView = const TabBarView(children: [Center(child: Text('Wird geladen...'))]);

  List<String> _groupFilter = [];
  List<String> _courseFilter = [];
  List<String> _teacherFilter = [];

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
    for (int offset = 0; offset < _maxTabBarLength; offset++) {
      DateTime now = DateTime.now();
      DateFormat format = DateFormat('yyyyMMdd');
      Map data;
      if (!kIsWeb) {
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
        data = response.data['payload'];
      } else {
        var jsonText = await rootBundle.loadString('assets/data/substitutions$offset.json');
        data = json.decode(jsonText)['payload'];
      }

      int planDate = data['showingNextDate'] ? data['nextDate'] : data['date'];

      setState(() {
        if (_substitutionData.length < _maxTabBarLength) {
          _substitutionData.add(data);
          _planNames.add(_getDateFormat(planDate.toString(), false));
        }
      });
      _loadFilters();
      _setTabBar();
    }
  }

  Future<void> _saveFilters() async {
    SharedPreferences prefs = await _prefs;

    prefs.setStringList('groupFilter', _groupFilter);
    prefs.setStringList('courseFilter', _courseFilter);
    prefs.setStringList('teacherFilter', _teacherFilter);
  }

  Future<void> _loadFilters() async {
    SharedPreferences prefs = await _prefs;

    setState(() {
      _groupFilter = prefs.getStringList('groupFilter') ?? [];
      _courseFilter = prefs.getStringList('courseFilter') ?? [];
      _teacherFilter = prefs.getStringList('teacherFilter') ?? [];
    });
  }

  Future<void> _resetFilters() async {
    setState(() {
      _groupFilter = [];
      _courseFilter = [];
      _teacherFilter = [];
    });
    await _saveFilters();
  }

  String _getDateFormat(String date, bool onlyDates) {
    String now = DateFormat('yyyyMMdd').format(DateTime.now());
    int nowInt = int.parse(now);
    if (date != DateFormat('yyyyMMdd').format(DateTime.parse(date))) return 'Ungültiges Datum';
    int dateInt = int.parse(date);

    if (!onlyDates) {
      if (date == now) return 'Heute';
      if (dateInt == nowInt + 1) return 'Morgen';
      if (dateInt == nowInt - 1) return 'Gestern';
      if (dateInt > nowInt && dateInt < nowInt + 7) return DateFormat('EEEE', 'de').format(DateTime.parse(date));
    }
    return DateFormat('dd.MM.yyyy').format(DateTime.parse(date));
  }

  void _setTabBar() {
    List<Widget> tabs = [];
    for (int i = 0; i < _substitutionData.length; i++) {
      tabs.add(Tab(child: Text(_planNames[i])));
    }
    if (tabs.isEmpty) tabs.add(const Tab(child: Text('Wird geladen...')));

    setState(() {
      _tabBar = TabBar(tabs: tabs, isScrollable: true);
      _tabBarLength = tabs.length;
    });
    _updateTabViews();
  }

  bool _isInFilter(SubstitutionEntry entry) {
    if ((_groupFilter.isEmpty ||
            _groupFilter.map((e) => entry.group.toLowerCase().contains(e.toLowerCase())).contains(true)) &&
        (_courseFilter.isEmpty ||
            _courseFilter.map((e) => (entry.courseNew ?? '').toLowerCase().contains(e.toLowerCase())).contains(true) ||
            _courseFilter.map((e) => (entry.courseOld ?? '').toLowerCase().contains(e.toLowerCase())).contains(true)) &&
        (_teacherFilter.isEmpty ||
            _teacherFilter
                .map((e) => (entry.teacherNew ?? '').toLowerCase().contains(e.toLowerCase()))
                .contains(true) ||
            _teacherFilter
                .map((e) => (entry.teacherOld ?? '').toLowerCase().contains(e.toLowerCase()))
                .contains(true))) {
      return true;
    }
    return false;
  }

  void _updateTabViews() {
    List<Widget> tabViews = [];
    for (int i = 0; i < _substitutionData.length; i++) {
      List<SubstitutionEntry> unfilteredEntries = [];
      List<SubstitutionEntry> filteredEntries = [];

      for (int j = 0; j < (_substitutionData[i]['rows'] as List).length; j++) {
        unfilteredEntries.add(SubstitutionEntry.fromJson(_substitutionData[i]['rows'][j]));
      }

      for (SubstitutionEntry entry in unfilteredEntries) {
        if (_isInFilter(entry)) {
          filteredEntries.add(entry);
        }
      }

      String lastUpdate = _substitutionData[i]['lastUpdate'];
      String date = _getDateFormat(_substitutionData[i]['date'].toString(), true);

      tabViews.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Stand: ${lastUpdate.substring(0, lastUpdate.length - 3)}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      'Datum: $date',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            unfilteredEntries.isEmpty
                ? const Expanded(child: Center(child: Text('Keine Vertretungen')))
                : filteredEntries.isEmpty
                    ? const Expanded(child: Center(child: Text('Keine Ergebnisse für die ausgewählten Filter')))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: filteredEntries.length,
                          itemBuilder: (BuildContext context, int index) {
                            return filteredEntries[index];
                          },
                        ),
                      ),
          ],
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
    groupFilterController.text = _groupFilter.join(' ');

    TextEditingController courseFilterController = TextEditingController();
    courseFilterController.text = _courseFilter.join(' ');

    TextEditingController teacherFilterController = TextEditingController();
    teacherFilterController.text = _teacherFilter.join(' ');

    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Ergebnisse filtern'),
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Es werden nur Ergebnisse angezeigt, die auf alle drei Filter zutreffen.\n'
                    '\nMehrere Einträge sind durch Leerzeichen zu trennen.'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Klassen oder Klassenstufen',
                  ),
                  controller: groupFilterController,
                  onChanged: (text) {
                    setState(() {
                      _groupFilter = text.trim() == '' ? [] : text.trim().split(' ');
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
                      _courseFilter = text.trim() == '' ? [] : text.trim().split(' ');
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Lehrer (Nachname)',
                  ),
                  controller: teacherFilterController,
                  onChanged: (text) {
                    setState(() {
                      _teacherFilter = text.trim() == '' ? [] : text.trim().split(' ');
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () {
                    if (group!.level > 10) {
                      setState(() {
                        _groupFilter = [];
                        _courseFilter = userCourses.map((e) => e.title).toList();
                        _teacherFilter = [];
                      });
                    } else {
                      setState(() {
                        _groupFilter = [group!.name];
                        _courseFilter = [];
                        _teacherFilter = [];
                      });
                    }
                    _saveFilters();
                    groupFilterController.text = _groupFilter.join(' ');
                    courseFilterController.text = _courseFilter.join(' ');
                    teacherFilterController.text = _teacherFilter.join(' ');
                  },
                  child: Text('Auf ${group!.level > 10 ? 'Kurse' : 'Klasse'} anpassen'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                      child: ElevatedButton(
                        onPressed: () {
                          _resetFilters();
                          _updateTabViews();
                          setState(() {
                            groupFilterController.text = _groupFilter.join(' ');
                            courseFilterController.text = _courseFilter.join(' ');
                            teacherFilterController.text = _teacherFilter.join(' ');
                          });
                        },
                        child: const Text('Leeren'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                      child: ElevatedButton(
                        onPressed: () {
                          _saveFilters();
                          _updateTabViews();
                          Navigator.pop(context);
                        },
                        child: const Text('Speichern'),
                      ),
                    ),
                  ),
                ],
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
          title: const Text('Vertretungsplan'),
          actions: [
            IconButton(icon: const Icon(Icons.refresh), onPressed: () => _getSubstitutions()),
            IconButton(icon: const Icon(Icons.filter_alt), onPressed: () => _showFilterDialog(context)),
          ],
          bottom: _tabBar,
        ),
        drawer: const MCGDrawer(routeName: SubstitutionsScreen.routeName),
        body: _tabBarView,
      ),
    );
  }
}
