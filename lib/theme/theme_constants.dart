import 'package:flutter/material.dart';

Color colorPrimaryLight = Colors.lightGreen.shade800;
Color colorPrimaryDark = Colors.green.shade900;

Color colorAccentLight = Colors.greenAccent.shade700;
Color colorAccentDark = Colors.lightGreen.shade700;

Color colorStrokeLight = Colors.black;
Color colorStrokeDark = Colors.white;

Color colorSecondaryLight = Colors.green.shade300;
Color colorSecondaryDark = Colors.green.shade800;

Color colorTimetableRowLight = Colors.grey.shade400;
Color colorTimetableRowDark = Colors.grey.shade800;

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: colorPrimaryLight,
  appBarTheme: AppBarTheme(
    backgroundColor: colorPrimaryLight,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: colorPrimaryLight,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(backgroundColor: colorPrimaryLight)
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: colorPrimaryDark,
  appBarTheme: AppBarTheme(
    backgroundColor: colorPrimaryDark,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: colorPrimaryDark,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: colorPrimaryDark)
  ),
);