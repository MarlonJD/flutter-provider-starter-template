// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'src/common/models/auth_model.dart';
import 'src/common/models/theme_model.dart';
import 'src/common/routes/route.dart';

/// This is a reimplementation of the default Flutter application using provider + [ChangeNotifier].
void main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeModel(),
        ),
      ],
      // child: const MyApp(),
      child: EasyLocalization(
          supportedLocales: [Locale('en', 'US'), Locale('tr', 'TR')],
          path: 'assets/translations',
          fallbackLocale: Locale('tr', 'TR'),
          child: MainRouter()),
    ),
  );
}
