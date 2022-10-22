import 'package:flutter/material.dart';
import 'package:mcgapp/theme/theme_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager with ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  ThemeMode _themeMode = ThemeMode.light;
  Color _colorStroke = colorStrokeLight;

  get themeMode => _themeMode;

  get colorStroke => _colorStroke;

  Future<ThemeMode> getThemeMode() async {
    final SharedPreferences prefs = await _prefs;
    final bool isDark = prefs.getBool('isDarkMode') ?? false;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('isDarkMode', themeMode == ThemeMode.dark);
    notifyListeners();
  }

  loadTheme() async {
    _themeMode = await getThemeMode();
    notifyListeners();
  }

  toggleTheme(bool isDark) async {
    await setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    await loadTheme();

    if (isDark) {
      _colorStroke = colorStrokeDark;
    } else {
      _colorStroke = colorStrokeLight;
    }
    notifyListeners();
  }
}
