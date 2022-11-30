// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:hive_flutter/hive_flutter.dart';

/// A mock authentication service
class AuthModel with ChangeNotifier {
  bool? _signedIn;
  bool? get signedIn => _signedIn;

  AuthModel() {
    getPreferences();
  }

  static const authBoxKey = "authBoxKey";
  static const authKey = "authKey";

  getPreferences() async {
    _signedIn = await getAuthState();
    print(_signedIn);
    notifyListeners();
  }

  getAuthState() async {
    var box = await Hive.openBox(authBoxKey);
    return box.get(authKey) ?? false;
  }

  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    // Write to the box
    var box = await Hive.openBox(authBoxKey);
    await box.put(authKey, false);
    await box.close();

    // Sign out.
    _signedIn = false;
    notifyListeners();
  }

  Future<bool?> signIn(String username, String password) async {
    // Write to the box
    var box = await Hive.openBox(authBoxKey);
    await box.put(authKey, true);
    await box.close();

    // Sign in. Allow any password.
    _signedIn = true;

    notifyListeners();
    return _signedIn;
  }

  @override
  bool operator ==(Object other) =>
      other is AuthModel && other._signedIn == _signedIn;

  @override
  int get hashCode => _signedIn.hashCode;
}

class AuthModelScope extends InheritedNotifier<AuthModel> {
  const AuthModelScope({
    required super.notifier,
    required super.child,
    super.key,
  });

  static AuthModel of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AuthModelScope>()!.notifier!;
}
