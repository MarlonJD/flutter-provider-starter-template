// Flutter imports:

import 'package:flutter/widgets.dart';
// Package imports:
import 'package:hive_flutter/hive_flutter.dart';

/// A mock authentication service
class AuthModel with ChangeNotifier {
  /// Get user state from Hive
  AuthModel() {
    getPreferences();
  }

  bool? _signedIn;

  /// Sign in the user
  bool? get signedIn => _signedIn;

  /// Auth Box Key for Hive
  static const authBoxKey = "authBoxKey";

  /// Auth auth key for Hive on Auth Box
  static const authKey = "authKey";

  /// Get the user state from Hive
  Future<void> getPreferences() async {
    _signedIn = await getAuthState();
    debugPrint(_signedIn.toString());
    notifyListeners();
  }

  /// Get the user state from Hive
  Future<bool?> getAuthState() async {
    // ignore: inference_failure_on_function_invocation
    final box = await Hive.openBox(authBoxKey);
    return box.get(authKey) as bool? ?? false;
  }

  /// Sign Out from Hive and notify listeners
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    // Write to the box
    // ignore: inference_failure_on_function_invocation
    final box = await Hive.openBox(authBoxKey);
    await box.put(authKey, false);
    await box.close();

    // Sign out.
    _signedIn = false;
    notifyListeners();
  }

  /// Sign In from Hive and notify listeners
  Future<bool?> signIn(String username, String password) async {
    /// Write to the box
    // ignore: inference_failure_on_function_invocation
    final box = await Hive.openBox(authBoxKey);
    await box.put(authKey, true);
    await box.close();

    /// Sign in. Allow any password.
    _signedIn = true;

    notifyListeners();
    return _signedIn;
  }
}

/// Auth Model Scope using for go_router without provider
class AuthModelScope extends InheritedNotifier<AuthModel> {
  /// Scope for Auth Model
  const AuthModelScope({
    required super.notifier,
    required super.child,
    super.key,
  });

  /// Notifier boilerplate
  static AuthModel of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AuthModelScope>()!.notifier!;
}
