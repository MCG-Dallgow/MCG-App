import 'package:flutter/material.dart';
import 'package:mcgapp/theme/theme_constants.dart';

class ThemeManager with ChangeNotifier {

  ThemeMode _themeMode = ThemeMode.light;
  Color _colorStroke = colorStrokeLight;

  get themeMode => _themeMode;
  get colorStroke => _colorStroke;

  toggleTheme(bool isDark) {
    if (isDark) {
      _themeMode = ThemeMode.dark;
      _colorStroke = colorStrokeDark;
    } else {
      _themeMode = ThemeMode.light;
      _colorStroke = colorStrokeLight;
    }
    notifyListeners();
  }


}