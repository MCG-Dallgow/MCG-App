import 'package:flutter/material.dart';

Color colorPrimaryLight = Colors.lightGreen.shade800;
Color colorPrimaryDark = Colors.green.shade900;

Color colorAccentLight = Colors.greenAccent.shade700;
Color colorAccentDark = Colors.lightGreen.shade700;

Color colorBackgroundLight = Colors.lightGreenAccent.shade100;
Color colorBackgroundDark = Colors.greenAccent.shade400;

Color colorStrokeLight = Colors.black;
Color colorStrokeDark = Colors.white;

Color colorSecondaryLight = Colors.green.shade300;
Color colorSecondaryDark = Colors.green.shade800;

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: colorPrimaryLight,
  backgroundColor: colorBackgroundLight,
  appBarTheme: AppBarTheme(
    backgroundColor: colorPrimaryLight,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: colorPrimaryLight,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: colorPrimaryDark,
  backgroundColor: colorBackgroundDark,
  appBarTheme: AppBarTheme(
    backgroundColor: colorPrimaryDark,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: colorPrimaryDark,
  ),
);