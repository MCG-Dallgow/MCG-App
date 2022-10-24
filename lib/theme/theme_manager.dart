import 'package:flutter/material.dart';
import 'package:mcgapp/theme/theme_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager with ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  ThemeMode _themeMode = ThemeMode.light;
  Color _colorStroke = colorStrokeLight;
  Color _colorSecondary = colorSecondaryLight;

  get themeMode => _themeMode;

  get colorStroke => _colorStroke;
  get colorSecondary => _colorSecondary;

  Future<ThemeMode> _getThemeMode() async {
    final SharedPreferences prefs = await _prefs;
    final bool isDark = prefs.getBool('isDarkMode') ?? false;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> _setThemeMode(ThemeMode themeMode) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('isDarkMode', themeMode == ThemeMode.dark);
    notifyListeners();
  }

  loadTheme() async {
    _themeMode = await _getThemeMode();
    _setColors(themeMode == ThemeMode.dark);
    notifyListeners();
  }

  _setColors(bool isDark) {
    if (isDark) {
      _colorStroke = colorStrokeDark;
      _colorSecondary = colorSecondaryDark;
    } else {
      _colorStroke = colorStrokeLight;
      _colorSecondary = colorSecondaryLight;
    }
  }

  toggleTheme(bool isDark) async {
    await _setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    await loadTheme();

    _setColors(isDark);
    notifyListeners();
  }
}
