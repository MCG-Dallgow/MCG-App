import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mcgapp/screens/teacher_details_screen.dart';
import 'package:mcgapp/widgets/drawer.dart';

import '../classes/teacher.dart';

class TeacherListScreen extends StatefulWidget {
  const TeacherListScreen({Key? key}) : super(key: key);

  @override
  State<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends State<TeacherListScreen> {
  final List<Teacher> _teachers = [];
  final List<Teacher> _entries = [];

  Future<void> loadJsonData() async {
    var jsonText = await rootBundle.loadString("assets/data/teachers.json");
    setState(() {
      List data = json.decode(jsonText)['teachers'];
      for (int i = 0; i < data.length; i++) {
        _teachers.add(Teacher.fromJson(data, i));
      }
      _entries.addAll(_teachers);
    });
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
    ModalRoute.of(context)
        ?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;

      _entries.clear();
      for (Teacher teacher in _teachers) {
        if (teacher.nachname
                .toLowerCase()
                .startsWith(searchQuery.toLowerCase()) ||
            "${teacher.anrede} ${teacher.nachname}"
                .toLowerCase()
                .startsWith(searchQuery.toLowerCase()) ||
            teacher.vorname
                .toLowerCase()
                .startsWith(searchQuery.toLowerCase()) ||
            teacher.kuerzel
                .toLowerCase()
                .startsWith(searchQuery.toLowerCase())) {
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
    loadJsonData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            leading: _isSearching ? const BackButton() : null,
            title:
                _isSearching ? _buildSearchField() : const Text("Lehrerliste"),
            actions: _buildActions(),
          ),
          drawer: const MCGDrawer(),
          body: _entries.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _entries.length * 2,
                  itemBuilder: (BuildContext context, int index) {
                    if (index.isOdd) {
                      return const Divider();
                    }
                    return ListTile(
                      //leading: CircleAvatar(),
                      title: Text(
                          "${_entries[index ~/ 2].anrede} ${_entries[index ~/ 2].nachname}"),
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return TeacherDetailsScreen(teacher: _entries[index ~/ 2]);
                        }));
                      },
                    );
                  })
              : const Center(child: Text("keine Treffer"))),
    );
  }
}
