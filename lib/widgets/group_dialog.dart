import 'package:flutter/material.dart';
import 'package:mcgapp/classes/course.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enums/group.dart';

Future<void> chooseGroup(BuildContext context, bool overwrite) async {
  if (group == null || overwrite) group = await _showGroupChoosingDialog(context);
  courses = await Course.getCourses(group!);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('group', group!.name);
  userCourses = prefs.getStringList('courses-${group!.name}')?.map((title) => Course.fromTitle(title)).toList() ?? [];
}

Future<Group> _showGroupChoosingDialog(BuildContext context) async {
  Group group = await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return const _GroupChoosingDialog();
    },
  );
  return group;
}

class _GroupChoosingDialog extends StatefulWidget {
  const _GroupChoosingDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<_GroupChoosingDialog> createState() => _GroupChoosingDialogState();
}

class _GroupChoosingDialogState extends State<_GroupChoosingDialog> {
  final List<Group> _groups = Group.values;
  Group? _selectedGroup = group;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SimpleDialog(
        title: const Text('Wähle deine Klasse bzw. dein Tutoriat'),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: _groups.length,
                  itemBuilder: (BuildContext context, int index) {
                    Group group = _groups[index];
                    return RadioListTile(
                      title: Row(
                        children: [
                          Text(group.name),
                          Text(' (${group.teacher.lastname})', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      value: _groups[index],
                      groupValue: _selectedGroup,
                      onChanged: (Group? value) {
                        setState(() {
                          _selectedGroup = _groups[index];
                        });
                      },
                    );
                  },
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: _selectedGroup == null ? Colors.grey : null),
                    onPressed: () {
                      if (_selectedGroup != null) {
                        Navigator.pop(context, _selectedGroup);
                      }
                    },
                    child: const Text('Fertig'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
