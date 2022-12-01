import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:testprovider/src/common/models/theme_model.dart';
import 'package:testprovider/src/common/routes/route.dart';

/// This is a reimplementation of the default
/// Flutter application using provider + [ChangeNotifier].
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
        supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
        path: 'assets/translations',
        fallbackLocale: const Locale('tr', 'TR'),
        child: MainRouter(),
      ),
    ),
  );
}
