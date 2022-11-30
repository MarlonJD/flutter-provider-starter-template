// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hive_flutter/hive_flutter.dart';

class ThemeModel with ChangeNotifier, DiagnosticableTreeMixin {
  late bool _isDark;
  late ThemeService _preferences;
  bool get isDark => _isDark;

  ThemeModel() {
    _isDark = false;
    _preferences = ThemeService();
    getPreferences();
  }

  //Switching the themes
  set isDark(bool value) {
    _isDark = value;
    _preferences.setTheme(value);
    notifyListeners();
  }

  getPreferences() async {
    _isDark = await _preferences.getTheme();
    notifyListeners();
  }
}

class ThemeService {
  final darkTheme = ThemeData(
    colorSchemeSeed: Colors.blue,
    brightness: Brightness.dark,
    useMaterial3: true,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
  );

  final lightTheme = ThemeData(
    colorSchemeSeed: Colors.blue,
    brightness: Brightness.light,
    useMaterial3: true,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
  );

  static const themeBoxKey = "themeBoxKey";
  static const themeKey = "themeKey";

  setTheme(bool value) async {
    var box = await Hive.openBox(themeBoxKey);
    await box.put(themeKey, value);
    await box.close();
  }

  getTheme() async {
    var box = await Hive.openBox(themeBoxKey);
    return box.get(themeKey) ?? false;
  }
}
