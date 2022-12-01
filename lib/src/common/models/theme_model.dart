// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:hive_flutter/hive_flutter.dart';

/// General Theme Model for the app
class ThemeModel with ChangeNotifier, DiagnosticableTreeMixin {
  /// Initialize the theme model
  ThemeModel() {
    _isDark = false;
    _preferences = ThemePreference();
    getPreferences();
  }

  late bool _isDark;
  late ThemePreference _preferences;

  /// Get current theme state
  bool get isDark => _isDark;

  /// Switching the themes
  set isDark(bool value) {
    _isDark = value;
    _preferences.setTheme(state: value);
    notifyListeners();
  }

  /// Get the theme preferences from Hive
  Future<void> getPreferences() async {
    _isDark = (await _preferences.getTheme())!;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isDark', isDark));
  }
}

/// Main Theme Service
class ThemePreference {
  /// Dark Theme of the app
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

  /// Light Theme of the app
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

  /// Theme Box Key for Hive
  static const String themeBoxKey = "themeBoxKey";

  /// Theme key for Hive on Theme Box
  static const String themeKey = "themeKey";

  /// Set theme state to Hive
  Future<void> setTheme({bool? state}) async {
    // ignore: inference_failure_on_function_invocation
    final box = await Hive.openBox(themeBoxKey);
    await box.put(themeKey, state);
    await box.close();
  }

  /// Get theme state from Hive
  Future<bool?> getTheme() async {
    // ignore: inference_failure_on_function_invocation
    final box = await Hive.openBox(
      themeBoxKey,
    );
    return box.get(themeKey) as bool? ?? false;
  }
}
