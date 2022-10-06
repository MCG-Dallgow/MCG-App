import 'package:flutter/material.dart';

Color colorPrimary = Colors.lightGreen.shade800;
Color colorAccent = Colors.greenAccent.shade700;
Color colorBackground = Colors.lightGreenAccent.shade100;

Color colorStrokeLight = Colors.black;
Color colorStrokeDark = Colors.white;

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: colorPrimary,
  backgroundColor: colorBackground,
  appBarTheme: AppBarTheme(
    backgroundColor: colorPrimary,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: colorAccent,
  )
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
);