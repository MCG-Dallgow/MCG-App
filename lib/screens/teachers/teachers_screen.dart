import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mcgapp/main.dart';
import 'package:mcgapp/screens/teachers/teacher_details_screen.dart';
import 'package:mcgapp/widgets/drawer.dart';

import '../../classes/teacher.dart';
import '../../widgets/app_bar.dart';

class TeachersScreen extends StatefulWidget {
  const TeachersScreen({Key? key}) : super(key: key);

  static const String routeName = '/teachers';

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  final List<Teacher> _teachers = [];
  final List<Teacher> _entries = [];
  final List<String> sekretariat = [];
  final Map<String, CircleAvatar> _teacherImages = {};

  Future<void> _loadTeachers() async {
    var jsonText = await rootBundle.loadString('assets/data/teachers.json');
    Map<String, Teacher> teachers = await Teacher.getTeachers();
    setState(() {
      _teachers.addAll(teachers.values);
      _entries.addAll(_teachers);

      sekretariat.add(json.decode(jsonText)['sekretariat']['email'] as String);
      sekretariat.add(json.decode(jsonText)['sekretariat']['phone'] as String);
    });

    for (Teacher teacher in _teachers) {
      String path = 'assets/images/teachers/${teacher.short}.jpg';
      CircleAvatar teacherImage = await rootBundle.load(path).then((value) {
        return CircleAvatar(
          backgroundImage: AssetImage(path),
          radius: 24,
        );
      }).catchError((_) {
        return CircleAvatar(
          backgroundColor: themeManager.colorSecondary,
          radius: 24,
          child: Icon(Icons.person_rounded, color: themeManager.colorStroke, size: 32),
        );
      });
      setState(() {
        _teacherImages[teacher.short] = teacherImage;
      });
    }
  }

  final TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = '';

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Suchen...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white54),
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              if (_searchQueryController.text.isEmpty) {
                Navigator.pop(context);
                return;
              }
              _clearSearchQuery();
            }),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;

      _entries.clear();
      for (Teacher teacher in _teachers) {
        if (teacher.lastname.toLowerCase().startsWith(searchQuery.toLowerCase()) ||
            '${teacher.title} ${teacher.lastname}'.toLowerCase().startsWith(searchQuery.toLowerCase()) ||
            teacher.firstname.toLowerCase().startsWith(searchQuery.toLowerCase()) ||
            teacher.short.toLowerCase().startsWith(searchQuery.toLowerCase())) {
          _entries.add(teacher);
        }
      }
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery('');
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTeachers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MCGAppBar(
        leading: _isSearching ? const BackButton() : null,
        title: _isSearching ? _buildSearchField() : const Text('Lehrer'),
        actions: _buildActions(),
      ),
      drawer: const MCGDrawer(routeName: TeachersScreen.routeName),
      body: _entries.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _entries.length * 2 + ((_entries.isNotEmpty && !_isSearching || searchQuery == '') ? 1 : 0),
              itemBuilder: (BuildContext context, int index) {
                if (index == 0 && (!_isSearching || searchQuery == '')) {
                  return ListTile(
                    title: const Text('Sekretariat'),
                    leading: const CircleAvatar(backgroundImage: AssetImage('assets/images/mcg-icon.jpg'), radius: 24),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        SekretariatScreen.routeName,
                        arguments: sekretariat,
                      );
                    },
                  );
                }
                if (index.isOdd) {
                  return const Divider();
                }
                int teacherIndex = index ~/ 2 - ((_entries.isNotEmpty && !_isSearching || searchQuery == '') ? 1 : 0);
                Teacher teacher = _entries[teacherIndex];

                return ListTile(
                  title: Text('${teacher.title} ${teacher.lastname}'),
                  leading: _teacherImages[teacher.short],
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      TeacherDetailsScreen.routeName,
                      arguments: _entries[teacherIndex],
                    );
                  },
                );
              })
          : const Center(child: Text('keine Treffer')),
    );
  }
}
