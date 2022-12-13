import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mcgapp/main.dart';

import '../../classes/teacher.dart';
import '../../widgets/app_bar.dart';

class TeacherDetailsScreen extends StatefulWidget {
  const TeacherDetailsScreen({Key? key}) : super(key: key);

  static const String routeName = '/teachers/details';

  @override
  State<TeacherDetailsScreen> createState() => _TeacherDetailsScreenState();
}

class _TeacherDetailsScreenState extends State<TeacherDetailsScreen> {
  Widget _teacherImage = Container();

  Future<void> _loadTeacherImage(Teacher teacher) async {
    String path = 'assets/images/teachers/${teacher.short}.jpg';

    Widget teacherImage = await rootBundle.load(path).then((value) {
      return SizedBox(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Image.asset(path, fit: BoxFit.contain, width: 500),
        ),
      );
    }).catchError((_) {
      return const SizedBox();
    });

    setState(() {
      _teacherImage = teacherImage;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final teacher = ModalRoute.of(context)!.settings.arguments as Teacher;
    _loadTeacherImage(teacher);

    return Scaffold(
      appBar: MCGAppBar(
        title: Text('${teacher.title} ${teacher.lastname}'),
      ),
      body: ListView(
        children: [
          _teacherImage,
          ListTile(
            title: Text('${teacher.firstname} ${teacher.lastname}' != ''
                ? '${teacher.firstname} ${teacher.lastname}'
                : 'kein vermerkter Name'),
            leading: const Icon(Icons.person),
          ),
          ListTile(
            title: Text(teacher.subjects.isNotEmpty
                ? teacher.subjects.map((e) => e.name).join(', ')
                : 'keine vermerkten Fächer'),
            leading: const Icon(Icons.subject),
          ),
          ListTile(
            title: Text(teacher.short != '' ? teacher.short : 'kein vermerkes Kürzel'),
            leading: const Icon(Icons.tag),
          ),
          ListTile(
            title: Text(teacher.email != '' ? teacher.email : 'keine vermerkte E-Mail-Adresse'),
            leading: const Icon(Icons.email),
            trailing: IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    elevation: 6,
                    backgroundColor: themeManager.colorSecondary,
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      'E-Mail-Adresse kopiert',
                      style: TextStyle(color: themeManager.colorStroke),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
                await Clipboard.setData(ClipboardData(text: teacher.email));
              },
            ),
          )
        ],
      ),
    );
  }
}

class SekretariatScreen extends StatelessWidget {
  const SekretariatScreen({Key? key}) : super(key: key);

  static const String routeName = '/teachers/office';

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as List<String>;

    return Scaffold(
      appBar: MCGAppBar(
        title: const Text('Sekretariat'),
      ),
      body: ListView(
        children: [
          Align(alignment: Alignment.centerLeft, child: Image.asset('assets/images/mcg-icon.png', width: 500)),
          ListTile(
            title: Text(data[0]),
            leading: const Icon(Icons.email),
          ),
          ListTile(
            title: Text(data[1]),
            leading: const Icon(Icons.phone),
          ),
        ],
      ),
    );
  }
}
