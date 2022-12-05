import 'package:flutter/material.dart';
import 'package:mcgapp/screens/credits_screen.dart';
import 'package:mcgapp/screens/grades/course_grades_screen.dart';
import 'package:mcgapp/screens/grades/grade_edit_screen.dart';
import 'package:mcgapp/screens/grades/grades_screen.dart';
import 'package:mcgapp/screens/home_screen.dart';
import 'package:mcgapp/screens/roomplan_screen.dart';
import 'package:mcgapp/screens/settings_screen.dart';
import 'package:mcgapp/screens/substitutions_screen.dart';
import 'package:mcgapp/screens/teachers/teacher_details_screen.dart';
import 'package:mcgapp/screens/teachers/teachers_screen.dart';
import 'package:mcgapp/screens/timetable_screen.dart';
import 'package:mcgapp/theme/theme_constants.dart';
import 'package:mcgapp/theme/theme_manager.dart';

import 'classes/room.dart';
import 'classes/teacher.dart';

void main() {
  runApp(const MyApp());
}

String get appName => 'MCG-App';
String get appVersion => '0.3.0-beta.2';

ThemeManager themeManager = ThemeManager();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _loadValuesFromJson() async {
    teachers = await Teacher.getTeachers();
    rooms = await Room.getRooms();
  }

  @override
  void initState() {
    _loadValuesFromJson();
    themeManager.loadTheme();
    themeManager.addListener(themeListener);
    super.initState();
  }

  @override
  void dispose() {
    themeManager.removeListener(themeListener);
    super.dispose();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeManager.themeMode,
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        TimetableScreen.routeName: (context) => const TimetableScreen(),
        SubstitutionsScreen.routeName: (context) => const SubstitutionsScreen(),
        RoomplanScreen.routeName: (context) => const RoomplanScreen(),
        TeachersScreen.routeName: (context) => const TeachersScreen(),
        TeacherDetailsScreen.routeName: (context) => const TeacherDetailsScreen(),
        SekretariatScreen.routeName: (context) => const SekretariatScreen(),
        GradesScreen.routeName: (context) => const GradesScreen(),
        GradeEditScreen.routeName: (context) => const GradeEditScreen(),
        CourseGradesScreen.routeName: (context) => const CourseGradesScreen(),
        SettingsScreen.routeName: (context) => const SettingsScreen(),
        CreditsScreen.routeName: (context) => const CreditsScreen(),
      },
    );
  }
}
