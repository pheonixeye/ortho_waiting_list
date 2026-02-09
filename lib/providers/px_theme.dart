import 'package:flutter/material.dart';
import 'package:urology_waiting_list/utils/shared_prefs.dart';

class PxTheme extends ChangeNotifier {
  PxTheme() {
    _init();
  }
  void _init() async {
    final _storedThemeMode = await asyncPrefs.getString('theme');
    if (_storedThemeMode == 'dark') {
      _mode = ThemeMode.dark;
      notifyListeners();
    } else if (_storedThemeMode == 'light') {
      _mode = ThemeMode.light;
      notifyListeners();
    } else {
      _mode = ThemeMode.system;
      notifyListeners();
    }
  }

  ThemeMode? _mode;
  ThemeMode? get mode => _mode;

  Future<void> switchTheme(ThemeMode mode) async {
    _mode = mode;
    notifyListeners();
    switch (mode) {
      case ThemeMode.system:
        return;
      default:
        await asyncPrefs.setString('theme', mode.name);
        break;
    }
  }

  bool get isDark => _mode == ThemeMode.dark;
}
